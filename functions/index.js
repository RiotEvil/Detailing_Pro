const admin = require("firebase-admin");
const {logger} = require("firebase-functions");
const {onDocumentWritten, onDocumentCreated, onDocumentUpdated} = require("firebase-functions/v2/firestore");
const {onRequest} = require("firebase-functions/v2/https");
const {onSchedule} = require("firebase-functions/v2/scheduler");
const {defineSecret} = require("firebase-functions/params");

admin.initializeApp();

const REGION = "europe-west3";
const MAX_TOKENS_PER_REQUEST = 500;
const DEFAULT_TIMEZONE = "Europe/Warsaw";
const PLAN_SYNC_MIN_INTERVAL_MS = 15 * 1000;
const BILLING_AUDIT_RETENTION_DAYS = 180;
const revenueCatSecret = defineSecret("REVENUECAT_SECRET_KEY");
const twilioAccountSid = defineSecret("TWILIO_ACCOUNT_SID");
const twilioAuthToken = defineSecret("TWILIO_AUTH_TOKEN");
// TWILIO_FROM_NUMBER is read from env (not a managed secret) so deployment
// succeeds even before the number is provisioned. SMS sending is skipped
// gracefully when the value is absent.
const _twilioFromNumber = () => process.env.TWILIO_FROM_NUMBER || "";

// Resend API key — managed secret (email notifications)
const resendApiKey = defineSecret("RESEND_API_KEY");

/** Escapes HTML special characters to prevent XSS in email templates. */
function escapeHtml(str) {
  return String(str ?? "")
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#39;");
}

const DAY_MS = 24 * 60 * 60 * 1000;
// SMS reminder lead-time windows (ms before appointment)
const SMS_WINDOWS = [
  {label: "24h", leadMs: 24 * 60 * 60 * 1000, windowMs: 5 * 60 * 1000, field: "smsReminder24hSentAt"},
  {label: "2h",  leadMs:  2 * 60 * 60 * 1000, windowMs: 5 * 60 * 1000, field: "smsReminder2hSentAt"},
];
// Max SMS per billing period per plan
const SMS_PLAN_LIMITS = {free: 0, pro: 100, business: 500};

// Email reminder lead-time windows
const EMAIL_WINDOWS = [
  {label: "24h", leadMs: 24 * 60 * 60 * 1000, windowMs: 5 * 60 * 1000, field: "emailReminder24hSentAt"},
  {label: "2h",  leadMs:  2 * 60 * 60 * 1000, windowMs: 5 * 60 * 1000, field: "emailReminder2hSentAt"},
];
// Max emails per billing period per plan (generous — email is cheap)
const EMAIL_PLAN_LIMITS = {free: 50, pro: 500, business: 2000};
// Max orders fetched per scheduler page to prevent timeout / memory spikes
const SCHEDULER_PAGE_SIZE = 200;
const BOOKING_REQUEST_RATE_LIMIT_MAX = 6;
const BOOKING_REQUEST_RATE_LIMIT_WINDOW_MS = 60 * 60 * 1000;
const BOOKING_REQUEST_ALLOWED_FIELDS = [
  "masterUid",
  "clientName",
  "clientPhone",
  "clientEmail",
  "service",
  "car",
  "note",
  "preferredDate",
  "preferredTime",
  "locale",
  "source",
];

const DEFAULT_SCHEDULE = {
  slotMinutes: 30,
  minNoticeMinutes: 60,
  days: {
    "1": {start: "09:00", end: "18:00", breaks: [{start: "13:00", end: "14:00"}]},
    "2": {start: "09:00", end: "18:00", breaks: [{start: "13:00", end: "14:00"}]},
    "3": {start: "09:00", end: "18:00", breaks: [{start: "13:00", end: "14:00"}]},
    "4": {start: "09:00", end: "18:00", breaks: [{start: "13:00", end: "14:00"}]},
    "5": {start: "09:00", end: "18:00", breaks: [{start: "13:00", end: "14:00"}]},
    "6": {start: "10:00", end: "15:00", breaks: []},
    "0": null,
  },
};

const ALLOWED_ORIGINS = [
  "https://detailing-pro.web.app",
  "https://detailing-pro.firebaseapp.com",
];

// Free-tier quotas (must match lib/core/access_guard.dart and firestore.rules).
const FREE_CLIENT_LIMIT = 20;
const FREE_ACTIVE_ORDERS_PER_MONTH_LIMIT = 10;

function planStatusGrantsAccess(status) {
  const normalized = String(status || "inactive").toLowerCase();
  return normalized === "active" || normalized === "trial" || normalized === "grace";
}

function orgHasProAccessFromData(orgData) {
  const plan = String(orgData?.plan || "free").toLowerCase();
  return (plan === "pro" || plan === "business") &&
    planStatusGrantsAccess(orgData?.planStatus);
}

function orgHasBusinessAccessFromData(orgData) {
  const plan = String(orgData?.plan || "free").toLowerCase();
  return plan === "business" && planStatusGrantsAccess(orgData?.planStatus);
}

async function loadOrgAccessForUid(db, uid) {
  const userSnap = await db.collection("users").doc(uid).get();
  const orgId = String(userSnap.data()?.orgId || "").trim();
  if (!orgId) {
    return {orgId: null, hasPro: false, hasBusiness: false, orgData: {}};
  }
  const orgSnap = await db.collection("organizations").doc(orgId).get();
  const orgData = orgSnap.data() || {};
  return {
    orgId,
    hasPro: orgHasProAccessFromData(orgData),
    hasBusiness: orgHasBusinessAccessFromData(orgData),
    orgData,
  };
}

function currentMonthKey(date = new Date()) {
  return `${date.getFullYear()}-${date.getMonth() + 1}`;
}

function isActiveOrderStatus(status) {
  const s = String(status || "").toLowerCase();
  return s !== "completed" && s !== "paid";
}

function orderTimestampMs(data) {
  if (!data) return null;
  const ts = data.timestamp;
  if (!ts) return null;
  if (typeof ts.toMillis === "function") return ts.toMillis();
  if (typeof ts === "number" && Number.isFinite(ts)) return ts;
  return null;
}

function isOrderInMonth(data, year, month) {
  const ms = orderTimestampMs(data);
  if (ms == null) return false;
  const d = new Date(ms);
  return d.getFullYear() === year && d.getMonth() + 1 === month;
}

function isActiveOrderInCurrentMonth(data) {
  if (!data) return false;
  const now = new Date();
  return (
    isActiveOrderStatus(data.status) &&
    isOrderInMonth(data, now.getFullYear(), now.getMonth() + 1)
  );
}

function orgQuotaDefaults() {
  const monthKey = currentMonthKey();
  return {
    clientCount: 0,
    activeOrdersThisMonthCount: 0,
    activeOrdersMonthKey: monthKey,
    quotasInitializedAt: admin.firestore.FieldValue.serverTimestamp(),
  };
}

async function recountClientCount(db, orgId) {
  const coll = db.collection(`organizations/${orgId}/clients`);
  const agg = await coll.count().get();
  const count = Number(agg.data().count) || 0;
  await db.collection("organizations").doc(orgId).set(
    {
      clientCount: count,
      clientCountUpdatedAt: admin.firestore.FieldValue.serverTimestamp(),
    },
    {merge: true},
  );
  return count;
}

async function recountActiveOrdersThisMonth(db, orgId) {
  const now = new Date();
  const year = now.getFullYear();
  const month = now.getMonth() + 1;
  const monthKey = currentMonthKey(now);

  const ordersSnap = await db.collection(`organizations/${orgId}/orders`).get();
  let count = 0;
  for (const doc of ordersSnap.docs) {
    const data = doc.data();
    if (!isActiveOrderStatus(data.status)) continue;
    if (!isOrderInMonth(data, year, month)) continue;
    count += 1;
  }

  await db.collection("organizations").doc(orgId).set(
    {
      activeOrdersThisMonthCount: count,
      activeOrdersMonthKey: monthKey,
      activeOrdersQuotaUpdatedAt: admin.firestore.FieldValue.serverTimestamp(),
    },
    {merge: true},
  );
  return count;
}

async function applyClientCountDelta(db, orgId, delta) {
  if (!delta) return;
  const orgRef = db.collection("organizations").doc(orgId);

  const needsRecount = await db.runTransaction(async (tx) => {
    const orgSnap = await tx.get(orgRef);
    const raw = orgSnap.data()?.clientCount;
    if (!Number.isFinite(Number(raw))) {
      return true;
    }
    const next = Math.max(0, Number(raw) + delta);
    tx.set(
      orgRef,
      {
        clientCount: next,
        clientCountUpdatedAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      {merge: true},
    );
    return false;
  });

  if (needsRecount) {
    await recountClientCount(db, orgId);
  }
}

async function applyActiveOrdersDelta(db, orgId, delta) {
  if (!delta) return;
  const orgRef = db.collection("organizations").doc(orgId);
  const monthKey = currentMonthKey();

  const needsRecount = await db.runTransaction(async (tx) => {
    const orgSnap = await tx.get(orgRef);
    const data = orgSnap.data() || {};
    const storedKey = String(data.activeOrdersMonthKey || "");
    const rawCount = data.activeOrdersThisMonthCount;

    if (storedKey !== monthKey || !Number.isFinite(Number(rawCount))) {
      return true;
    }

    const next = Math.max(0, Number(rawCount) + delta);
    tx.set(
      orgRef,
      {
        activeOrdersThisMonthCount: next,
        activeOrdersMonthKey: monthKey,
        activeOrdersQuotaUpdatedAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      {merge: true},
    );
    return false;
  });

  if (needsRecount) {
    await recountActiveOrdersThisMonth(db, orgId);
  }
}

function withCors(req, res) {
  const origin = req.headers.origin || "";
  const allowedOrigin = ALLOWED_ORIGINS.includes(origin)
    ? origin
    : ALLOWED_ORIGINS[0];
  res.set("Access-Control-Allow-Origin", allowedOrigin);
  res.set("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
  res.set("Access-Control-Allow-Headers", "Content-Type, Authorization");

  if (req.method === "OPTIONS") {
    res.status(204).send("");
    return true;
  }
  return false;
}

function parseJsonObjectBody(req) {
  if (req.body && typeof req.body === "object" && !Array.isArray(req.body)) {
    return req.body;
  }

  if (typeof req.body === "string") {
    try {
      const parsed = JSON.parse(req.body);
      if (parsed && typeof parsed === "object" && !Array.isArray(parsed)) {
        return parsed;
      }
    } catch (_) {
      return null;
    }
  }

  return null;
}

function requestClientIp(req) {
  const forwardedFor = String(req.headers["x-forwarded-for"] || "").split(",")[0].trim();
  const directIp = String(req.ip || req.socket && req.socket.remoteAddress || "").trim();
  return forwardedFor || directIp || "unknown";
}

function sanitizeRateLimitKeyPart(raw, maxLength = 80) {
  const normalized = String(raw || "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "_")
    .replace(/^_+|_+$/g, "");

  if (!normalized) {
    return "unknown";
  }

  return normalized.slice(0, maxLength);
}

async function consumeBookingRateLimit(db, masterUid, ipSanitized) {
  const rateRef = db.collection("booking_rate_limits").doc(`${masterUid}_${ipSanitized}`);
  const nowMs = Date.now();
  let allowed = true;
  let retryAfterMs = 0;
  let count = 1;

  await db.runTransaction(async (tx) => {
    const snap = await tx.get(rateRef);
    const data = snap.data() || {};
    const windowStartMs = Number(data.windowStartMs);
    const currentCount = Number(data.count);
    const inWindow =
      Number.isFinite(windowStartMs) &&
      nowMs - windowStartMs >= 0 &&
      nowMs - windowStartMs < BOOKING_REQUEST_RATE_LIMIT_WINDOW_MS;

    if (!inWindow) {
      count = 1;
      tx.set(rateRef, {
        windowStartMs: nowMs,
        count,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      }, {merge: true});
      return;
    }

    const safeCount = Number.isFinite(currentCount) && currentCount > 0 ? currentCount : 0;
    if (safeCount >= BOOKING_REQUEST_RATE_LIMIT_MAX) {
      allowed = false;
      count = safeCount;
      retryAfterMs = Math.max(
        0,
        BOOKING_REQUEST_RATE_LIMIT_WINDOW_MS - (nowMs - windowStartMs),
      );
      tx.set(rateRef, {
        windowStartMs,
        count: safeCount,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      }, {merge: true});
      return;
    }

    count = safeCount + 1;
    tx.set(rateRef, {
      windowStartMs,
      count,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    }, {merge: true});
  });

  return {allowed, retryAfterMs, count};
}

exports.createBookingRequest = onRequest(
  {
    region: REGION,
    memory: "256MiB",
    maxInstances: 10,
    invoker: "public",
  },
  async (req, res) => {
    if (withCors(req, res)) return;

    if (req.method !== "POST") {
      logger.info("createBookingRequest rejected: method-not-allowed", {method: req.method});
      res.status(405).json({error: "method-not-allowed"});
      return;
    }

    const payload = parseJsonObjectBody(req);
    if (!payload) {
      logger.warn("createBookingRequest rejected: invalid-json-body");
      res.status(400).json({error: "invalid-json-body"});
      return;
    }

    const unknownFields = Object.keys(payload).filter(
      (key) => !BOOKING_REQUEST_ALLOWED_FIELDS.includes(key),
    );
    if (unknownFields.length > 0) {
      logger.warn("createBookingRequest rejected: unknown-fields", {unknownFields});
      res.status(400).json({error: "invalid-payload", reason: "unknown-fields"});
      return;
    }

    const errors = [];

    function requiredString(field, maxLen, pattern) {
      const raw = payload[field];
      if (typeof raw !== "string") {
        errors.push(`${field}-type`);
        return null;
      }

      const value = raw.trim();
      if (!value) {
        errors.push(`${field}-empty`);
        return null;
      }

      if (value.length > maxLen) {
        errors.push(`${field}-length`);
        return null;
      }

      if (pattern && !pattern.test(value)) {
        errors.push(`${field}-format`);
        return null;
      }

      return value;
    }

    function optionalString(field, maxLen, pattern) {
      const raw = payload[field];
      if (raw == null) {
        return null;
      }

      if (typeof raw !== "string") {
        errors.push(`${field}-type`);
        return null;
      }

      const value = raw.trim();
      if (!value) {
        return null;
      }

      if (value.length > maxLen) {
        errors.push(`${field}-length`);
        return null;
      }

      if (pattern && !pattern.test(value)) {
        errors.push(`${field}-format`);
        return null;
      }

      return value;
    }

    const masterUid = requiredString("masterUid", 128, /^[A-Za-z0-9_-]{1,128}$/);
    const clientName = requiredString("clientName", 100);
    const clientPhone = optionalString("clientPhone", 30, /^[0-9+()\-.\s]{5,30}$/);
    const clientEmail = optionalString("clientEmail", 120, /^[^\s@]+@[^\s@]+\.[^\s@]+$/);
    const service = requiredString("service", 200);
    const car = requiredString("car", 100);
    const note = optionalString("note", 1000);
    const preferredDate = requiredString("preferredDate", 32, /^\d{4}-\d{2}-\d{2}$/);
    const preferredTime = requiredString("preferredTime", 32, /^\d{1,2}:\d{2}$/);
    const locale = optionalString("locale", 10, /^[A-Za-z]{2}(?:-[A-Za-z]{2})?$/);
    const source = requiredString("source", 40, /^[A-Za-z0-9._-]{1,40}$/);

    if (preferredDate && !parseYmd(preferredDate)) {
      errors.push("preferredDate-format");
    }
    if (preferredTime && parseTimeToMinutes(preferredTime) == null) {
      errors.push("preferredTime-format");
    }

    if (errors.length > 0) {
      logger.warn("createBookingRequest rejected: invalid-payload", {
        errors,
        masterUid: masterUid || null,
      });
      res.status(400).json({error: "invalid-payload"});
      return;
    }

    const db = admin.firestore();
    const clientIp = requestClientIp(req);
    const ipSanitized = sanitizeRateLimitKeyPart(clientIp);

    try {
      const masterSnap = await db.collection("users").doc(masterUid).get();
      if (!masterSnap.exists) {
        logger.warn("createBookingRequest rejected: master-not-found", {masterUid});
        res.status(400).json({error: "invalid-masterUid"});
        return;
      }

      const masterAccess = await loadOrgAccessForUid(db, masterUid);
      if (!masterAccess.hasPro) {
        logger.info("createBookingRequest rejected: pro-plan-required", {masterUid});
        res.status(403).json({error: "online-booking-not-available"});
        return;
      }

      const limit = await consumeBookingRateLimit(db, masterUid, ipSanitized);
      if (!limit.allowed) {
        logger.info("createBookingRequest rejected: rate-limited", {
          masterUid,
          ipSanitized,
          retryAfterMs: limit.retryAfterMs,
        });
        res.status(429).json({error: "rate-limited", retryAfterMs: limit.retryAfterMs});
        return;
      }

      const requestRef = await db.collection("booking_requests").add({
        masterUid,
        clientName,
        clientPhone,
        clientEmail,
        service,
        car,
        note,
        preferredDate,
        preferredTime,
        locale,
        source,
        status: "pending",
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      logger.info("createBookingRequest created", {
        requestId: requestRef.id,
        masterUid,
        ipSanitized,
      });
      res.status(200).json({ok: true, requestId: requestRef.id});
    } catch (error) {
      logger.error("createBookingRequest failed", {
        error: String(error),
        masterUid,
        ipSanitized,
      });
      res.status(500).json({error: "internal"});
    }
  },
);

function parseIsoMs(value) {
  if (!value || typeof value !== "string") return null;
  const ms = Date.parse(value);
  return Number.isFinite(ms) ? ms : null;
}

function parseFirestoreMs(value) {
  if (!value) return null;
  if (typeof value.toMillis === "function") {
    return value.toMillis();
  }
  if (typeof value === "number" && Number.isFinite(value)) {
    return value;
  }
  if (typeof value === "string") {
    const parsed = Date.parse(value);
    return Number.isFinite(parsed) ? parsed : null;
  }
  return null;
}

function isEntitlementActive(entitlement, nowMs) {
  if (!entitlement || typeof entitlement !== "object") {
    return false;
  }

  const expiresMs = parseIsoMs(entitlement.expires_date);
  const graceMs = parseIsoMs(entitlement.grace_period_expires_date);

  if (expiresMs == null) {
    return true;
  }

  if (expiresMs > nowMs) {
    return true;
  }

  return graceMs != null && graceMs > nowMs;
}

function derivePlanStatus(entitlement, nowMs) {
  if (!entitlement || typeof entitlement !== "object") {
    return "inactive";
  }

  const graceMs = parseIsoMs(entitlement.grace_period_expires_date);
  const billingIssueMs = parseIsoMs(entitlement.billing_issues_detected_at);
  const periodType = String(entitlement.period_type || "").toLowerCase();

  if ((graceMs != null && graceMs > nowMs) || billingIssueMs != null) {
    return "grace";
  }

  if (periodType.includes("trial")) {
    return "trial";
  }

  return "active";
}

function resolvePlanFromSubscriber(subscriber) {
  const nowMs = Date.now();
  const entitlements = subscriber && subscriber.entitlements &&
      typeof subscriber.entitlements === "object"
    ? subscriber.entitlements
    : {};

  const businessEntitlement = entitlements.business;
  const proEntitlement = entitlements.pro;

  if (isEntitlementActive(businessEntitlement, nowMs)) {
    return {
      plan: "business",
      planStatus: derivePlanStatus(businessEntitlement, nowMs),
      billingProvider: "revenuecat",
    };
  }

  if (isEntitlementActive(proEntitlement, nowMs)) {
    return {
      plan: "pro",
      planStatus: derivePlanStatus(proEntitlement, nowMs),
      billingProvider: "revenuecat",
    };
  }

  return {
    plan: "free",
    planStatus: "inactive",
    billingProvider: "revenuecat",
  };
}

async function verifyAuthAndGetUid(req) {
  const authHeader = String(req.headers.authorization || "");
  if (!authHeader.toLowerCase().startsWith("bearer ")) {
    return null;
  }

  const token = authHeader.substring(7).trim();
  if (!token) {
    return null;
  }

  const decoded = await admin.auth().verifyIdToken(token);
  return decoded && decoded.uid ? decoded.uid : null;
}

const INVITE_CODE_ALPHABET = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
const INVITE_CODE_LENGTH = 6;

function isTeamRole(role) {
  return role === "director" || role === "masterOwner" || role === "master";
}

function fallbackSeatLimitByPlan(plan) {
  return String(plan || "").toLowerCase() === "business" ? 5 : 1;
}

function resolveSeatLimit(orgData) {
  const explicit = Number(orgData && orgData.seatLimit);
  const fallback = fallbackSeatLimitByPlan(orgData && orgData.plan);
  if (!Number.isFinite(explicit) || explicit <= 0) {
    return fallback;
  }
  return Math.max(fallback, Math.round(explicit));
}

async function countActiveMembersByOrg(db, orgId) {
  const usersSnap = await db.collection("users").where("orgId", "==", orgId).get();
  return usersSnap.docs.filter((doc) => isTeamRole(String((doc.data() || {}).role || ""))).length;
}

async function countPendingInvitesByOrg(db, orgId) {
  const pendingInvites = await db
    .collection("invites")
    .where("orgId", "==", orgId)
    .where("used", "==", false)
    .get();
  return pendingInvites.size;
}

async function ensureTeamSeatAvailable(db, orgId, includePendingInvites = false) {
  const orgRef = db.collection("organizations").doc(orgId);
  const orgSnap = await orgRef.get();
  const seatLimit = resolveSeatLimit(orgSnap.data() || {});
  const activeMembers = await countActiveMembersByOrg(db, orgId);
  const pendingInvites = includePendingInvites
    ? await countPendingInvitesByOrg(db, orgId)
    : 0;

  return {
    seatLimit,
    activeMembers,
    pendingInvites,
    available: activeMembers + pendingInvites < seatLimit,
  };
}

function generateInviteCodeValue() {
  let out = "";
  for (let i = 0; i < INVITE_CODE_LENGTH; i += 1) {
    const idx = Math.floor(Math.random() * INVITE_CODE_ALPHABET.length);
    out += INVITE_CODE_ALPHABET[idx];
  }
  return out;
}

async function generateUniqueInviteCode(db) {
  for (let i = 0; i < 20; i += 1) {
    const code = generateInviteCodeValue();
    const snap = await db.collection("invites").doc(code).get();
    if (!snap.exists) {
      return code;
    }
  }

  throw new Error("invite-code-generation-failed");
}

function inviteError(code, extras = {}) {
  const err = new Error(code);
  err.code = code;
  Object.assign(err, extras);
  return err;
}

exports.syncPlanStatus = onRequest(
  {
    region: REGION,
    memory: "256MiB",
    maxInstances: 5,
    invoker: "public",
    secrets: [revenueCatSecret],
  },
  async (req, res) => {
    if (withCors(req, res)) return;

    if (req.method !== "POST") {
      res.status(405).json({error: "method-not-allowed"});
      return;
    }

    let uid;
    try {
      uid = await verifyAuthAndGetUid(req);
    } catch (error) {
      logger.error("syncPlanStatus auth verification failed", error);
      res.status(401).json({error: "unauthorized"});
      return;
    }

    if (!uid) {
      res.status(401).json({error: "unauthorized"});
      return;
    }

    const revenueCatApiKey = String(revenueCatSecret.value() || "").trim();
    if (!revenueCatApiKey) {
      res.status(503).json({error: "revenuecat-secret-missing"});
      return;
    }

    try {
      const firestore = admin.firestore();
      const userRef = firestore.collection("users").doc(uid);
      const userSnap = await userRef.get();
      const userData = userSnap.data() || {};

      const nowMs = Date.now();
      const lastPlanSyncMs = parseFirestoreMs(userData.lastPlanSyncAt);
      if (lastPlanSyncMs != null && nowMs - lastPlanSyncMs < PLAN_SYNC_MIN_INTERVAL_MS) {
        const retryAfterMs = PLAN_SYNC_MIN_INTERVAL_MS - (nowMs - lastPlanSyncMs);
        res.status(429).json({
          error: "rate-limited",
          retryAfterMs,
        });
        return;
      }

      const rcResponse = await fetch(
        `https://api.revenuecat.com/v1/subscribers/${encodeURIComponent(uid)}`,
        {
          method: "GET",
          headers: {
            Authorization: `Bearer ${revenueCatApiKey}`,
            "Content-Type": "application/json",
          },
        },
      );

      if (!rcResponse.ok) {
        const details = await rcResponse.text();
        logger.error("syncPlanStatus revenuecat request failed", {
          status: rcResponse.status,
          uid,
          details,
        });
        res.status(502).json({error: "revenuecat-fetch-failed"});
        return;
      }

      const rcPayload = await rcResponse.json();
      const subscriber = rcPayload && rcPayload.subscriber ? rcPayload.subscriber : null;
      const resolved = resolvePlanFromSubscriber(subscriber);
      const seatLimit = resolved.plan === "business" ? 5 : 1;

      const orgId = userData.orgId;
      const canUpdateOrgPlan = typeof orgId === "string" && orgId.trim().length > 0;
      const previousPlan = String(userData.plan || "free");
      const previousStatus = String(userData.planStatus || "inactive");
      const previousProvider = String(userData.billingProvider || "unknown");

      const batch = firestore.batch();
      batch.set(
        userRef,
        {
          plan: resolved.plan,
          planStatus: resolved.planStatus,
          billingProvider: resolved.billingProvider,
          lastPlanSyncAt: admin.firestore.FieldValue.serverTimestamp(),
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        },
        {merge: true},
      );

      if (canUpdateOrgPlan) {
        batch.set(firestore.collection("organizations").doc(orgId),
          {
            plan: resolved.plan,
            planStatus: resolved.planStatus,
            billingProvider: resolved.billingProvider,
            seatLimit,
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
          },
          {merge: true},
        );
      }

      const changed =
        previousPlan !== resolved.plan ||
        previousStatus !== resolved.planStatus ||
        previousProvider !== resolved.billingProvider;

      if (changed) {
        const auditRef = firestore.collection("billing_audit").doc();
        batch.set(auditRef, {
          uid,
          orgId: typeof orgId === "string" ? orgId : null,
          source: "syncPlanStatus",
          previous: {
            plan: previousPlan,
            planStatus: previousStatus,
            billingProvider: previousProvider,
          },
          current: {
            plan: resolved.plan,
            planStatus: resolved.planStatus,
            billingProvider: resolved.billingProvider,
          },
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();

      res.status(200).json({
        ok: true,
        plan: resolved.plan,
        planStatus: resolved.planStatus,
        billingProvider: resolved.billingProvider,
      });
    } catch (error) {
      logger.error("syncPlanStatus failed", error);
      res.status(500).json({error: "internal"});
    }
  },
);

exports.functionsHealth = onRequest(
  {
    region: REGION,
    memory: "128MiB",
    maxInstances: 2,
    invoker: "public",
  },
  async (req, res) => {
    if (withCors(req, res)) return;

    if (req.method !== "GET") {
      res.status(405).json({error: "method-not-allowed"});
      return;
    }

    res.status(200).json({
      ok: true,
      service: "detailing-pro-functions",
      region: REGION,
      timestamp: new Date().toISOString(),
    });
  },
);

// Reconcile client/order quota counters for the caller's organization.
// Safe to call on every cloud sync start (idempotent full recount).
exports.ensureOrgQuotas = onRequest(
  {
    region: REGION,
    memory: "256MiB",
    maxInstances: 10,
    invoker: "public",
  },
  async (req, res) => {
    if (withCors(req, res)) return;

    if (req.method !== "POST") {
      res.status(405).json({error: "method-not-allowed"});
      return;
    }

    let uid;
    try {
      uid = await verifyAuthAndGetUid(req);
    } catch (error) {
      logger.error("ensureOrgQuotas: auth verification failed", error);
      res.status(401).json({error: "unauthorized"});
      return;
    }
    if (!uid) {
      res.status(401).json({error: "unauthorized"});
      return;
    }

    try {
      const db = admin.firestore();
      const userSnap = await db.collection("users").doc(uid).get();
      const orgId = String(userSnap.data()?.orgId || "").trim();
      if (!orgId) {
        res.status(400).json({error: "missing-org"});
        return;
      }

      const clientCount = await recountClientCount(db, orgId);
      const activeOrdersThisMonthCount = await recountActiveOrdersThisMonth(db, orgId);

      res.status(200).json({
        ok: true,
        orgId,
        clientCount,
        activeOrdersThisMonthCount,
        activeOrdersMonthKey: currentMonthKey(),
      });
    } catch (error) {
      logger.error("ensureOrgQuotas failed", error);
      res.status(500).json({error: "internal"});
    }
  },
);

// ── Set Business Mode ──────────────────────────────────────────────────────
// Called by the Flutter client when the user selects or changes business mode.
// Uses Admin SDK to write orgId/role/businessMode fields that Firestore rules
// prevent the client from writing directly (privilege escalation protection).
exports.setBusinessMode = onRequest(
  {
    region: REGION,
    memory: "256MiB",
    maxInstances: 5,
    invoker: "public",
  },
  async (req, res) => {
    if (withCors(req, res)) return;

    if (req.method !== "POST") {
      res.status(405).json({ error: "method-not-allowed" });
      return;
    }

    let uid;
    try {
      uid = await verifyAuthAndGetUid(req);
    } catch (error) {
      logger.error("setBusinessMode: auth verification failed", error);
      res.status(401).json({ error: "unauthorized" });
      return;
    }
    if (!uid) {
      res.status(401).json({ error: "unauthorized" });
      return;
    }

    const body = req.body && typeof req.body === "object"
      ? req.body
      : {};
    const mode = String(body.mode || "").trim().toLowerCase();
    if (mode !== "solo" && mode !== "team") {
      res.status(400).json({ error: "invalid-mode", expected: "solo or team" });
      return;
    }

    try {
      const db = admin.firestore();
      const userRef = db.collection("users").doc(uid);
      const userSnap = await userRef.get();
      const userData = userSnap.data() || {};

      const orgId = `org_${uid}`;
      const role = mode === "team" ? "director" : "masterOwner";
      const existingOrgId = String(userData.orgId || "").trim();
      const existingRole = String(userData.role || "").trim().toLowerCase();

      if (existingOrgId && existingOrgId !== orgId) {
        res.status(403).json({ error: "forbidden-org-change" });
        return;
      }

      if (existingRole === "master") {
        res.status(403).json({ error: "role-escalation-blocked" });
        return;
      }

      if (mode === "team") {
        const orgSnap = await db.collection("organizations").doc(orgId).get();
        if (!orgHasBusinessAccessFromData(orgSnap.data() || {})) {
          res.status(403).json({error: "business-plan-required"});
          return;
        }
      }

      // Write org document (safe — uses Admin SDK, bypasses rules)
      await db.collection("organizations").doc(orgId).set({
        orgId,
        ownerId: uid,
        businessMode: mode,
        ...orgQuotaDefaults(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      }, { merge: true });

      // Write sensitive user fields (not allowed from client via rules)
      await userRef.set({
        orgId,
        businessMode: mode,
        role,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      }, { merge: true });

      // Update public profile
      await db.collection("public_users").doc(uid).set({
        orgId,
        businessMode: mode,
        role,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      }, { merge: true });

      logger.info("setBusinessMode: done", { uid, mode, orgId, role });
      res.status(200).json({ ok: true, orgId, role, mode });
    } catch (error) {
      logger.error("setBusinessMode: failed", { uid, error: String(error) });
      res.status(500).json({ error: "internal" });
    }
  },
);

exports.generateInviteCode = onRequest(
  {
    region: REGION,
    memory: "256MiB",
    maxInstances: 5,
    invoker: "public",
  },
  async (req, res) => {
    if (withCors(req, res)) return;

    if (req.method !== "POST") {
      res.status(405).json({error: "method-not-allowed"});
      return;
    }

    let uid;
    try {
      uid = await verifyAuthAndGetUid(req);
    } catch (error) {
      logger.error("generateInviteCode: auth verification failed", error);
      res.status(401).json({error: "unauthorized"});
      return;
    }
    if (!uid) {
      res.status(401).json({error: "unauthorized"});
      return;
    }

    const body = req.body && typeof req.body === "object" ? req.body : {};

    try {
      const db = admin.firestore();
      const userSnap = await db.collection("users").doc(uid).get();
      const userData = userSnap.data() || {};

      const orgId = String(userData.orgId || "").trim();
      const role = String(userData.role || "").trim();
      const requestedOrgId = String(body.orgId || "").trim();
      const requestedDirectorUid = String(body.directorUid || "").trim();

      if (!orgId) {
        res.status(400).json({error: "missing-org"});
        return;
      }

      if (role !== "director" && role !== "masterOwner") {
        res.status(403).json({error: "forbidden"});
        return;
      }

      if (requestedOrgId && requestedOrgId !== orgId) {
        res.status(403).json({error: "forbidden-org"});
        return;
      }

      if (requestedDirectorUid && requestedDirectorUid !== uid) {
        res.status(403).json({error: "forbidden-director"});
        return;
      }

      const orgSnap = await db.collection("organizations").doc(orgId).get();
      if (!orgHasBusinessAccessFromData(orgSnap.data() || {})) {
        res.status(403).json({error: "business-plan-required"});
        return;
      }

      const seat = await ensureTeamSeatAvailable(db, orgId, true);
      if (!seat.available) {
        res.status(409).json({
          error: "seat-limit-reached",
          seatLimit: seat.seatLimit,
        });
        return;
      }

      const code = await generateUniqueInviteCode(db);
      await db.collection("invites").doc(code).set({
        code,
        orgId,
        directorUid: uid,
        used: false,
        usedBy: null,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        usedAt: null,
      });

      res.status(200).json({ok: true, code, orgId});
    } catch (error) {
      logger.error("generateInviteCode failed", {uid, error: String(error)});
      res.status(500).json({error: "internal"});
    }
  },
);

exports.joinWithInviteCode = onRequest(
  {
    region: REGION,
    memory: "256MiB",
    maxInstances: 10,
    invoker: "public",
  },
  async (req, res) => {
    if (withCors(req, res)) return;

    if (req.method !== "POST") {
      res.status(405).json({error: "method-not-allowed"});
      return;
    }

    let uid;
    try {
      uid = await verifyAuthAndGetUid(req);
    } catch (error) {
      logger.error("joinWithInviteCode: auth verification failed", error);
      res.status(401).json({error: "unauthorized"});
      return;
    }
    if (!uid) {
      res.status(401).json({error: "unauthorized"});
      return;
    }

    const body = req.body && typeof req.body === "object" ? req.body : {};
    const code = String(body.code || "").trim().toUpperCase();
    const requestedUid = String(body.userUid || "").trim();

    if (requestedUid && requestedUid !== uid) {
      res.status(403).json({error: "forbidden-user"});
      return;
    }

    if (code.length !== INVITE_CODE_LENGTH) {
      res.status(400).json({error: "invalid-code-format"});
      return;
    }

    try {
      const db = admin.firestore();
      const result = await db.runTransaction(async (tx) => {
        const inviteRef = db.collection("invites").doc(code);
        const userRef = db.collection("users").doc(uid);
        const publicUserRef = db.collection("public_users").doc(uid);

        const inviteSnap = await tx.get(inviteRef);
        if (!inviteSnap.exists) {
          throw inviteError("invalid-invite-code");
        }

        const inviteData = inviteSnap.data() || {};
        if (inviteData.used === true) {
          throw inviteError("invite-already-used");
        }

        const orgId = String(inviteData.orgId || "").trim();
        if (!orgId) {
          throw inviteError("invite-missing-org");
        }

        const userSnap = await tx.get(userRef);
        const userData = userSnap.data() || {};
        const existingOrgId = String(userData.orgId || "").trim();
        if (existingOrgId && existingOrgId !== orgId) {
          throw inviteError("user-already-in-other-org");
        }

        const orgRef = db.collection("organizations").doc(orgId);
        const orgSnap = await tx.get(orgRef);
        const seatLimit = resolveSeatLimit(orgSnap.data() || {});

        const usersSnap = await tx.get(
          db.collection("users").where("orgId", "==", orgId),
        );
        const activeMembers = usersSnap.docs.filter((doc) => {
          const data = doc.data() || {};
          return isTeamRole(String(data.role || ""));
        }).length;

        const joiningIsNewMember = !existingOrgId;
        if (joiningIsNewMember && activeMembers >= seatLimit) {
          throw inviteError("seat-limit-reached", {seatLimit});
        }

        tx.update(inviteRef, {
          used: true,
          usedBy: uid,
          usedAt: admin.firestore.FieldValue.serverTimestamp(),
        });

        tx.set(userRef, {
          orgId,
          role: "master",
          businessMode: "team",
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        }, {merge: true});

        tx.set(publicUserRef, {
          orgId,
          role: "master",
          businessMode: "team",
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        }, {merge: true});

        return {orgId};
      });

      res.status(200).json({ok: true, orgId: result.orgId});
    } catch (error) {
      const codeValue = String(error && error.code || "");
      if (codeValue === "invalid-invite-code") {
        res.status(404).json({error: "invalid-invite-code"});
        return;
      }
      if (codeValue === "invite-already-used") {
        res.status(409).json({error: "invite-already-used"});
        return;
      }
      if (codeValue === "seat-limit-reached") {
        res.status(409).json({
          error: "seat-limit-reached",
          seatLimit: Number(error && error.seatLimit) || 1,
        });
        return;
      }
      if (codeValue === "user-already-in-other-org") {
        res.status(403).json({error: "user-already-in-other-org"});
        return;
      }

      logger.error("joinWithInviteCode failed", {uid, error: String(error)});
      res.status(500).json({error: "internal"});
    }
  },
);

function clampNumber(value, fallback, min, max) {
  const n = Number(value);
  if (!Number.isFinite(n)) return fallback;
  return Math.min(max, Math.max(min, Math.round(n)));
}

function parseMonthRange(month) {
  const m = String(month || "").trim();
  const match = /^(\d{4})-(\d{2})$/.exec(m);
  if (!match) return null;
  const year = Number(match[1]);
  const mon = Number(match[2]);
  if (mon < 1 || mon > 12) return null;
  const start = new Date(Date.UTC(year, mon - 1, 1));
  const end = new Date(Date.UTC(year, mon, 0, 23, 59, 59, 999));
  return {startMs: start.getTime(), endMs: end.getTime(), year, month: mon};
}

function parseTimeToMinutes(raw) {
  if (typeof raw !== "string") return null;
  const match = /^(\d{1,2}):(\d{2})$/.exec(raw.trim());
  if (!match) return null;
  const hh = Number(match[1]);
  const mm = Number(match[2]);
  if (hh < 0 || hh > 23 || mm < 0 || mm > 59) return null;
  return hh * 60 + mm;
}

function minutesToTime(minutes) {
  const hh = String(Math.floor(minutes / 60)).padStart(2, "0");
  const mm = String(minutes % 60).padStart(2, "0");
  return `${hh}:${mm}`;
}

function parseYmd(raw) {
  const match = /^(\d{4})-(\d{2})-(\d{2})$/.exec(String(raw || "").trim());
  if (!match) return null;
  const y = Number(match[1]);
  const m = Number(match[2]);
  const d = Number(match[3]);
  if (m < 1 || m > 12 || d < 1 || d > 31) return null;
  return {y, m, d};
}

function ymdKeyFromUtcMs(ms) {
  const d = new Date(ms);
  const y = d.getUTCFullYear();
  const m = String(d.getUTCMonth() + 1).padStart(2, "0");
  const day = String(d.getUTCDate()).padStart(2, "0");
  return `${y}-${m}-${day}`;
}

function zonedPartsFromMs(ms, timeZone) {
  const formatter = new Intl.DateTimeFormat("en-GB", {
    timeZone,
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
    hourCycle: "h23",
  });
  const map = {};
  for (const part of formatter.formatToParts(new Date(ms))) {
    if (part.type !== "literal") {
      map[part.type] = part.value;
    }
  }

  const dayKey = `${map.year}-${map.month}-${map.day}`;
  const minutes = Number(map.hour || 0) * 60 + Number(map.minute || 0);
  return {dayKey, minutes};
}

function weekdayFromYmd(ymd) {
  return new Date(Date.UTC(ymd.y, ymd.m - 1, ymd.d)).getUTCDay();
}

function dayStartUtcMs(ymd) {
  return Date.UTC(ymd.y, ymd.m - 1, ymd.d, 0, 0, 0, 0);
}

function overlap(aStart, aEnd, bStart, bEnd) {
  return aStart < bEnd && bStart < aEnd;
}

function normalizeSchedule(raw) {
  const src = raw && typeof raw === "object" ? raw : {};
  const slotMinutes = clampNumber(src.slotMinutes, DEFAULT_SCHEDULE.slotMinutes, 15, 120);
  const minNoticeMinutes = clampNumber(
    src.minNoticeMinutes,
    DEFAULT_SCHEDULE.minNoticeMinutes,
    0,
    24 * 60,
  );
  const days = {};

  for (let day = 0; day <= 6; day += 1) {
    const key = String(day);
    const fallback = DEFAULT_SCHEDULE.days[key];
    const sourceDay = src.days && typeof src.days === "object" ? src.days[key] : undefined;
    const effective = sourceDay === undefined ? fallback : sourceDay;

    if (!effective || typeof effective !== "object") {
      days[key] = null;
      continue;
    }

    const startMinutes = parseTimeToMinutes(effective.start);
    const endMinutes = parseTimeToMinutes(effective.end);
    if (startMinutes == null || endMinutes == null || endMinutes <= startMinutes) {
      days[key] = null;
      continue;
    }

    const breaks = Array.isArray(effective.breaks) ? effective.breaks : [];
    const normalizedBreaks = breaks
      .map((b) => {
        const bStart = parseTimeToMinutes(b && b.start);
        const bEnd = parseTimeToMinutes(b && b.end);
        if (bStart == null || bEnd == null || bEnd <= bStart) return null;
        return {start: bStart, end: bEnd};
      })
      .filter(Boolean);

    days[key] = {
      start: startMinutes,
      end: endMinutes,
      breaks: normalizedBreaks,
    };
  }

  return {slotMinutes, minNoticeMinutes, days};
}

function timestampMs(raw) {
  if (!raw) return null;
  if (typeof raw.toMillis === "function") {
    return raw.toMillis();
  }
  if (typeof raw === "number" && Number.isFinite(raw)) {
    return raw;
  }
  return null;
}

function extractBookingIntervals(docs, fallbackDurationMinutes) {
  const out = [];
  for (const d of docs) {
    const data = d.data() || {};
    const status = String(data.status || "pending").toLowerCase();
    if (status !== "pending" && status !== "accepted") continue;

    const ymd = parseYmd(data.preferredDate);
    const startMinutes = parseTimeToMinutes(data.preferredTime);
    if (!ymd || startMinutes == null) continue;

    const duration = clampNumber(
      data.requestedDurationMinutes,
      fallbackDurationMinutes,
      15,
      8 * 60,
    );
    out.push({
      dayKey: `${String(ymd.y).padStart(4, "0")}-${String(ymd.m).padStart(2, "0")}-${String(ymd.d).padStart(2, "0")}`,
      start: startMinutes,
      end: startMinutes + duration,
    });
  }
  return out;
}

function extractOrderIntervals(
  docs,
  masterUid,
  fallbackDurationMinutes,
  businessMode,
  timeZone,
) {
  const out = [];
  for (const d of docs) {
    const data = d.data() || {};
    const status = String(data.status || "").toLowerCase();
    if (status === "completed" || status === "paid") continue;

    const assignedToUid = String(data.assignedToUid || "").trim();
    if (businessMode === "team") {
      if (!assignedToUid || assignedToUid !== masterUid) continue;
    }

    const ms = timestampMs(data.scheduledDate);
    if (!ms) continue;

    const zoned = zonedPartsFromMs(ms, timeZone);
    const duration = clampNumber(data.duration, fallbackDurationMinutes, 15, 8 * 60);

    out.push({
      dayKey: zoned.dayKey,
      start: zoned.minutes,
      end: zoned.minutes + duration,
    });
  }
  return out;
}

exports.getBookingAvailability = onRequest(
  {
    region: REGION,
    memory: "256MiB",
    maxInstances: 5,
    invoker: "public",
  },
  async (req, res) => {
    if (withCors(req, res)) return;

    if (req.method !== "GET") {
      res.status(405).json({error: "method-not-allowed"});
      return;
    }

    const masterUid = String(req.query.masterUid || "").trim();
    const month = String(req.query.month || "").trim();
    const timezone = String(req.query.timezone || DEFAULT_TIMEZONE).trim() || DEFAULT_TIMEZONE;
    const serviceDurationMinutes = clampNumber(req.query.serviceMinutes, 120, 30, 8 * 60);

    if (!masterUid) {
      res.status(400).json({error: "missing-masterUid"});
      return;
    }

    const monthRange = parseMonthRange(month);
    if (!monthRange) {
      res.status(400).json({error: "invalid-month", expected: "YYYY-MM"});
      return;
    }

    const db = admin.firestore();
    try {
      const users = db.collection("users");
      const userSnap = await users.doc(masterUid).get();
      if (!userSnap.exists) {
        res.status(404).json({error: "master-not-found"});
        return;
      }

      const userData = userSnap.data() || {};
      const masterAccess = await loadOrgAccessForUid(db, masterUid);
      if (!masterAccess.hasPro) {
        res.status(403).json({error: "online-booking-not-available"});
        return;
      }

      const orgId = String(userData.orgId || "").trim();
      const businessMode = String(userData.businessMode || "solo").trim().toLowerCase();
      const schedule = normalizeSchedule(userData.bookingSchedule);

      const requestsRef = db.collection("booking_requests");

      let indexFallbackUsed = false;

      const requestsPromise = requestsRef
        .where("masterUid", "==", masterUid)
        .where("preferredDate", ">=", `${month}-01`)
        .where("preferredDate", "<=", `${month}-31`)
        .get()
        .catch(async (error) => {
          const code = String(error && error.code || "");
          const msg = String(error && error.message || "").toLowerCase();
          const missingIndex =
            code.includes("failed-precondition") ||
            msg.includes("requires an index");

          if (!missingIndex) {
            throw error;
          }

          logger.warn("getBookingAvailability: composite index missing — using fallback with limit(200). Create index: booking_requests[masterUid, preferredDate] to fix.", {
            masterUid,
            month,
          });
          indexFallbackUsed = true;

          // Fallback path without composite index: fetch by masterUid only,
          // then filter month range in memory.
          const byMaster = await requestsRef
            .where("masterUid", "==", masterUid)
            .limit(200)
            .get();

          const lower = `${month}-01`;
          const upper = `${month}-31`;
          const filtered = byMaster.docs.filter((doc) => {
            const date = String((doc.data() || {}).preferredDate || "");
            return date >= lower && date <= upper;
          });

          return {docs: filtered};
        });

      const ordersPromise = orgId
        ? admin
            .firestore()
            .collection(`organizations/${orgId}/orders`)
            .where(
              "scheduledDate",
              ">=",
              admin.firestore.Timestamp.fromMillis(monthRange.startMs),
            )
            .where(
              "scheduledDate",
              "<=",
              admin.firestore.Timestamp.fromMillis(monthRange.endMs),
            )
            .get()
        : Promise.resolve({docs: []});

      const [requestsSnap, ordersSnap] = await Promise.all([
        requestsPromise,
        ordersPromise,
      ]);

      const intervalsByDay = new Map();

      const requestIntervals = extractBookingIntervals(
        requestsSnap.docs,
        serviceDurationMinutes,
      );
      const orderIntervals = extractOrderIntervals(
        ordersSnap.docs,
        masterUid,
        serviceDurationMinutes,
        businessMode,
        timezone,
      );

      for (const interval of [...requestIntervals, ...orderIntervals]) {
        const list = intervalsByDay.get(interval.dayKey) || [];
        list.push(interval);
        intervalsByDay.set(interval.dayKey, list);
      }

      const nowMs = Date.now();
      const minStartMs = nowMs + schedule.minNoticeMinutes * 60 * 1000;
      const slotsByDate = {};
      const availableDates = [];

      for (let dayMs = monthRange.startMs; dayMs <= monthRange.endMs; dayMs += DAY_MS) {
        const dayKey = ymdKeyFromUtcMs(dayMs);
        const ymd = parseYmd(dayKey);
        if (!ymd) continue;

        const weekday = weekdayFromYmd(ymd);
        const dayCfg = schedule.days[String(weekday)];
        if (!dayCfg) continue;

        const busy = intervalsByDay.get(dayKey) || [];
        const daySlots = [];

        for (
          let slotStart = dayCfg.start;
          slotStart + serviceDurationMinutes <= dayCfg.end;
          slotStart += schedule.slotMinutes
        ) {
          const slotEnd = slotStart + serviceDurationMinutes;
          const slotStartMs = dayStartUtcMs(ymd) + slotStart * 60 * 1000;
          if (slotStartMs < minStartMs) continue;

          let blocked = false;
          for (const br of dayCfg.breaks) {
            if (overlap(slotStart, slotEnd, br.start, br.end)) {
              blocked = true;
              break;
            }
          }
          if (blocked) continue;

          for (const iv of busy) {
            if (overlap(slotStart, slotEnd, iv.start, iv.end)) {
              blocked = true;
              break;
            }
          }
          if (blocked) continue;

          daySlots.push(minutesToTime(slotStart));
        }

        if (daySlots.length > 0) {
          slotsByDate[dayKey] = daySlots;
          availableDates.push(dayKey);
        }
      }

      res.status(200).json({
        masterUid,
        month,
        timezone,
        businessMode,
        serviceDurationMinutes,
        slotMinutes: schedule.slotMinutes,
        availableDates,
        slotsByDate,
        indexFallbackUsed,
        stats: {
          requestsConsidered: requestIntervals.length,
          ordersConsidered: orderIntervals.length,
        },
      });
    } catch (error) {
      logger.error("getBookingAvailability failed", error);
      res.status(500).json({ error: "internal" });
    }
  },
);

function chunk(array, size) {
  const chunks = [];
  for (let i = 0; i < array.length; i += size) {
    chunks.push(array.slice(i, i + size));
  }
  return chunks;
}

async function getDirectorUsers(orgId) {
  const snap = await admin
    .firestore()
    .collection("users")
    .where("orgId", "==", orgId)
    .get();

  return snap.docs
    .map((d) => ({id: d.id, ...d.data()}))
    .filter((u) => u.role === "director" || u.role === "masterOwner");
}

async function notifyOrgDirectors({orgId, title, body, data}) {
  const directors = await getDirectorUsers(orgId);

  if (directors.length === 0) {
    logger.info("No directors found for org", {orgId});
    return;
  }

  const tokensWithOwner = [];
  for (const director of directors) {
    const tokens = Array.isArray(director.fcmTokens) ? director.fcmTokens : [];
    for (const token of tokens) {
      if (typeof token === "string" && token.trim().length > 0) {
        tokensWithOwner.push({token: token.trim(), uid: director.id});
      }
    }
  }

  if (tokensWithOwner.length === 0) {
    logger.info("No FCM tokens for directors", {orgId});
    return;
  }

  const uniqueTokens = [...new Set(tokensWithOwner.map((x) => x.token))];
  const payload = {
    notification: {title, body},
    data: data || {},
  };

  let successCount = 0;
  const invalidByUser = new Map();

  for (const part of chunk(uniqueTokens, MAX_TOKENS_PER_REQUEST)) {
    const response = await admin.messaging().sendEachForMulticast({
      ...payload,
      tokens: part,
    });

    successCount += response.successCount;

    response.responses.forEach((r, i) => {
      if (r.success || !r.error) return;
      const code = r.error.code || "unknown";
      const token = part[i];
      const isInvalid =
        code.includes("registration-token-not-registered") ||
        code.includes("invalid-argument");

      if (!isInvalid) return;

      const owner = tokensWithOwner.find((t) => t.token === token);
      if (!owner) return;

      const current = invalidByUser.get(owner.uid) || [];
      current.push(token);
      invalidByUser.set(owner.uid, current);
    });
  }

  // Best-effort cleanup of invalid tokens in users/{uid}.fcmTokens
  const updates = [];
  invalidByUser.forEach((tokens, uid) => {
    updates.push(
      admin
        .firestore()
        .collection("users")
        .doc(uid)
        .set(
          {
            fcmTokens: admin.firestore.FieldValue.arrayRemove(...tokens),
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
          },
          {merge: true},
        ),
    );
  });
  await Promise.all(updates);

  logger.info("Director push sent", {
    orgId,
    title,
    attemptedTokens: uniqueTokens.length,
    successCount,
  });
}

exports.cleanupBillingAudit = onSchedule(
  {
    region: REGION,
    schedule: "every day 03:30",
    timeZone: DEFAULT_TIMEZONE,
    memory: "256MiB",
    maxInstances: 1,
  },
  async () => {
    const cutoffMs = Date.now() - BILLING_AUDIT_RETENTION_DAYS * DAY_MS;
    const cutoffTs = admin.firestore.Timestamp.fromMillis(cutoffMs);
    const db = admin.firestore();

    let deleted = 0;

    while (true) {
      const snap = await db
        .collection("billing_audit")
        .where("createdAt", "<=", cutoffTs)
        .limit(400)
        .get();

      if (snap.empty) {
        break;
      }

      const batch = db.batch();
      for (const doc of snap.docs) {
        batch.delete(doc.ref);
      }

      await batch.commit();
      deleted += snap.size;

      if (snap.size < 400) {
        break;
      }
    }

    logger.info("cleanupBillingAudit completed", {
      deleted,
      retentionDays: BILLING_AUDIT_RETENTION_DAYS,
    });
  },
);

function orderMessage(before, after) {
  if (!before.exists && after.exists) {
    const car = after.data().car || "New order";
    return {
      title: "New order",
      body: `${car} was created`,
      eventType: "order_created",
    };
  }

  if (before.exists && !after.exists) {
    const car = before.data().car || "Order";
    return {
      title: "Order deleted",
      body: `${car} was removed`,
      eventType: "order_deleted",
    };
  }

  const beforeData = before.data();
  const afterData = after.data();
  const car = afterData.car || beforeData.car || "Order";

  if (beforeData.status !== afterData.status) {
    return {
      title: "Order status changed",
      body: `${car}: ${beforeData.status || "unknown"} -> ${afterData.status || "unknown"}`,
      eventType: "order_status_changed",
    };
  }

  return {
    title: "Order updated",
    body: `${car} was updated`,
    eventType: "order_updated",
  };
}

function inventoryMessage(before, after) {
  if (!before.exists && after.exists) {
    const item = after.data().name || "Item";
    return {
      title: "Inventory item created",
      body: `${item} was added to inventory`,
      eventType: "inventory_created",
    };
  }

  if (before.exists && !after.exists) {
    const item = before.data().name || "Item";
    return {
      title: "Inventory item deleted",
      body: `${item} was removed from inventory`,
      eventType: "inventory_deleted",
    };
  }

  const beforeData = before.data();
  const afterData = after.data();
  const item = afterData.name || beforeData.name || "Item";
  const beforeAmount = Number(beforeData.amount || 0);
  const afterAmount = Number(afterData.amount || 0);
  const minStock = Number(afterData.minStock || 0);

  if (beforeAmount !== afterAmount) {
    if (minStock > 0 && afterAmount <= minStock) {
      return {
        title: "Low stock alert",
        body: `${item}: ${afterAmount} left (min ${minStock})`,
        eventType: "inventory_low_stock",
      };
    }

    return {
      title: "Inventory updated",
      body: `${item}: ${beforeAmount} -> ${afterAmount}`,
      eventType: "inventory_amount_changed",
    };
  }

  return {
    title: "Inventory updated",
    body: `${item} details were updated`,
    eventType: "inventory_updated",
  };
}

exports.onClientWritten = onDocumentWritten(
  {
    document: "organizations/{orgId}/clients/{clientId}",
    region: REGION,
  },
  async (event) => {
    const orgId = event.params.orgId;
    const before = event.data.before;
    const after = event.data.after;
    const db = admin.firestore();

    try {
      if (before.exists && !after.exists) {
        await applyClientCountDelta(db, orgId, -1);
      } else if (!before.exists && after.exists) {
        await applyClientCountDelta(db, orgId, 1);
      }
    } catch (error) {
      logger.error("onClientWritten: quota update failed, recounting", {
        orgId,
        clientId: event.params.clientId,
        error,
      });
      await recountClientCount(db, orgId);
    }
  },
);

exports.onOrderWritten = onDocumentWritten(
  {
    document: "organizations/{orgId}/orders/{orderId}",
    region: REGION,
  },
  async (event) => {
    const orgId = event.params.orgId;
    const orderId = event.params.orderId;
    const before = event.data.before;
    const after = event.data.after;
    const db = admin.firestore();

    try {
      const beforeData = before.exists ? before.data() : null;
      const afterData = after.exists ? after.data() : null;
      const beforeActive = isActiveOrderInCurrentMonth(beforeData);
      const afterActive = isActiveOrderInCurrentMonth(afterData);

      if (beforeActive !== afterActive) {
        let delta = 0;
        if (beforeActive) delta -= 1;
        if (afterActive) delta += 1;
        await applyActiveOrdersDelta(db, orgId, delta);
      }
    } catch (error) {
      logger.error("onOrderWritten: quota update failed, recounting", {
        orgId,
        orderId,
        error,
      });
      await recountActiveOrdersThisMonth(db, orgId);
    }

    const msg = orderMessage(before, after);

    await notifyOrgDirectors({
      orgId,
      title: msg.title,
      body: msg.body,
      data: {
        type: msg.eventType,
        orgId,
        entity: "order",
        entityId: orderId,
      },
    });
  },
);

exports.onInventoryWritten = onDocumentWritten(
  {
    document: "organizations/{orgId}/inventory/{itemId}",
    region: REGION,
  },
  async (event) => {
    const orgId = event.params.orgId;
    const itemId = event.params.itemId;
    const before = event.data.before;
    const after = event.data.after;

    const msg = inventoryMessage(before, after);

    await notifyOrgDirectors({
      orgId,
      title: msg.title,
      body: msg.body,
      data: {
        type: msg.eventType,
        orgId,
        entity: "inventory",
        entityId: itemId,
      },
    });
  },
);

// ── New booking request notification ────────────────────────────────────────
// Fires when a client submits a booking request from the public booking page.
// Notifies the target specialist (masterUid) via FCM push.
exports.onBookingRequestCreated = onDocumentCreated(
  {
    document: "booking_requests/{requestId}",
    region: REGION,
  },
  async (event) => {
    const data = event.data.data();
    const masterUid = data.masterUid;

    if (!masterUid || typeof masterUid !== "string") {
      logger.warn("onBookingRequestCreated: missing masterUid", {
        requestId: event.params.requestId,
      });
      return;
    }

    const userSnap = await admin
      .firestore()
      .collection("users")
      .doc(masterUid)
      .get();

    const userData = userSnap.data();
    if (!userData) {
      logger.warn("onBookingRequestCreated: user not found", {masterUid});
      return;
    }

    const tokens = Array.isArray(userData.fcmTokens)
      ? userData.fcmTokens.filter((t) => typeof t === "string" && t.trim().length > 0)
      : [];

    if (tokens.length === 0) {
      logger.info("onBookingRequestCreated: no FCM tokens for master", {masterUid});
      return;
    }

    const clientName = data.clientName || "Client";
    const service = data.service || "";
    const title = "New booking request";
    const body = service
      ? `${clientName} — ${service}`
      : clientName;

    const response = await admin.messaging().sendEachForMulticast({
      tokens,
      notification: {title, body},
      data: {
        type: "new_booking_request",
        masterUid,
        requestId: event.params.requestId,
      },
    });

    // Cleanup invalid tokens
    const invalidTokens = [];
    response.responses.forEach((r, i) => {
      if (!r.success && r.error) {
        const code = r.error.code || "";
        if (
          code.includes("registration-token-not-registered") ||
          code.includes("invalid-argument")
        ) {
          invalidTokens.push(tokens[i]);
        }
      }
    });

    if (invalidTokens.length > 0) {
      await admin
        .firestore()
        .collection("users")
        .doc(masterUid)
        .update({
          fcmTokens: admin.firestore.FieldValue.arrayRemove(...invalidTokens),
        });
    }

    logger.info("onBookingRequestCreated: push sent", {
      masterUid,
      successCount: response.successCount,
      requestId: event.params.requestId,
    });
  },
);

// ── Backend import: booking request accepted → create order + client ─────────
// Fires when a booking_request status changes TO 'accepted'.
// Uses importState field as an idempotency ledger:
//   undefined → 'processing' → 'done' | 'failed'
// This ensures exactly-once import even if the function retries.
// ── importBookingRequest ─────────────────────────────────────────────────────
// Shared import logic: find/create client and order from a booking_requests doc.
// Safe to call multiple times — guards against double-import.
async function importBookingRequest(db, requestId, afterData) {
  const requestRef = db.collection("booking_requests").doc(requestId);

  // Guard: check if already imported
  const currentSnap = await requestRef.get();
  if (currentSnap.exists && currentSnap.data().importState === "done") {
    logger.info("importBookingRequest: already done, skipping", {requestId});
    return;
  }

  try {
    const masterUid = String(afterData.masterUid || "").trim();
    if (!masterUid) {
      throw new Error("missing-masterUid");
    }

    // Resolve orgId from user document
    const userSnap = await db.collection("users").doc(masterUid).get();
    if (!userSnap.exists) {
      throw new Error("master-not-found");
    }
    const orgId = String(userSnap.data().orgId || "").trim();
    if (!orgId) {
      throw new Error("missing-orgId");
    }

    const clientName = String(afterData.clientName || "").trim();
    if (!clientName) {
      throw new Error("missing-clientName");
    }

    const clientPhone = String(afterData.clientPhone || "").trim();
    const car = String(afterData.car || "").trim();
    const service = String(afterData.service || "").trim();
    const note = String(afterData.note || "").trim();
    const preferredDate = String(afterData.preferredDate || "").trim();
    const preferredTime = String(afterData.preferredTime || "").trim();

    // Normalize phone: strip non-digits except leading +
    function normalizePhone(raw) {
      if (!raw) return "";
      let digits = raw.replace(/[^0-9+]/g, "");
      if (digits.startsWith("00")) digits = "+" + digits.substring(2);
      if (!digits.startsWith("+") && digits.length > 0) digits = "+" + digits;
      return digits;
    }
    const normalizedPhone = normalizePhone(clientPhone);

    // Parse scheduled date
    function parseScheduledDate(dateStr, timeStr) {
      const dateParts = (dateStr || "").split("-");
      if (dateParts.length !== 3) return admin.firestore.Timestamp.now();
      const [y, m, d] = dateParts.map(Number);
      const timeParts = (timeStr || "").split(":");
      const hour = timeParts.length > 0 ? Number(timeParts[0]) || 0 : 0;
      const minute = timeParts.length > 1 ? Number(timeParts[1]) || 0 : 0;
      return admin.firestore.Timestamp.fromDate(new Date(y, m - 1, d, hour, minute, 0));
    }

    function normalizeTime(timeStr) {
      const parts = (timeStr || "").split(":");
      const hour = parts.length > 0 ? (Number(parts[0]) || 0) : 0;
      const minute = parts.length > 1 ? (Number(parts[1]) || 0) : 0;
      return `${String(hour).padStart(2, "0")}:${String(minute).padStart(2, "0")}`;
    }

    const scheduledDate = parseScheduledDate(preferredDate, preferredTime);
    const scheduledTime = normalizeTime(preferredTime);

    const orgClientsRef = db.collection(`organizations/${orgId}/clients`);
    const orgOrdersRef = db.collection(`organizations/${orgId}/orders`);

    // Find or create client
    let clientId;
    let clientDocRef;
    if (normalizedPhone) {
      const existingSnap = await orgClientsRef
        .where("phone", "==", normalizedPhone)
        .limit(1)
        .get();
      if (!existingSnap.empty) {
        const existingDoc = existingSnap.docs[0];
        clientId = existingDoc.id;
        clientDocRef = existingDoc.ref;
        // Add car if not present
        const existingCars = Array.isArray(existingDoc.data().cars) ? existingDoc.data().cars : [];
        if (car && !existingCars.includes(car)) {
          await clientDocRef.update({
            cars: admin.firestore.FieldValue.arrayUnion(car),
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
          });
        }
      }
    }
    if (!clientId) {
      // Try find by name
      const nameSnap = await orgClientsRef
        .where("name", "==", clientName)
        .limit(1)
        .get();
      if (!nameSnap.empty) {
        clientId = nameSnap.docs[0].id;
        clientDocRef = nameSnap.docs[0].ref;
        const existingCars = Array.isArray(nameSnap.docs[0].data().cars) ? nameSnap.docs[0].data().cars : [];
        if (car && !existingCars.includes(car)) {
          await clientDocRef.update({
            cars: admin.firestore.FieldValue.arrayUnion(car),
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
          });
        }
      } else {
        // Create new client
        const newClientRef = orgClientsRef.doc();
        clientId = newClientRef.id;
        await newClientRef.set({
          id: clientId,
          name: clientName,
          phone: normalizedPhone || null,
          cars: car ? [car] : [],
          notes: note || null,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
      }
    }

    // Create order with deterministic ID = requestId (idempotent)
    const orderId = requestId;
    const orderRef = orgOrdersRef.doc(orderId);
    const orderSnap = await orderRef.get();
    if (!orderSnap.exists) {
      const orderNotes = note ? `Source: online-booking\n${note}` : "Source: online-booking";
      await orderRef.set({
        id: orderId,
        clientId,
        car: car || "",
        client: clientName,
        service: service || "",
        duration: 0,
        price: 0,
        status: "scheduled",
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        scheduledDate,
        scheduledTime,
        notes: orderNotes,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        source: "online-booking",
        bookingRequestId: requestId,
      });
    }

    // Mark request as imported
    await requestRef.update({
      importState: "done",
      importedToApp: true,
      importedAt: admin.firestore.FieldValue.serverTimestamp(),
      importedOrderId: orderId,
      importedClientId: clientId,
    });

    logger.info("importBookingRequest: import done", {requestId, orderId, clientId, orgId});
  } catch (err) {
    logger.error("importBookingRequest: import failed", {requestId, err: String(err)});
    await requestRef.update({importState: "failed"}).catch(() => {});
    throw err;
  }
}

exports.onBookingRequestAccepted = onDocumentUpdated(
  {
    document: "booking_requests/{requestId}",
    region: REGION,
  },
  async (event) => {
    const requestId = event.params.requestId;
    const before = event.data.before.data();
    const after = event.data.after.data();

    // Only act when transitioning to 'accepted'
    if (!after || after.status !== "accepted" || (before && before.status === "accepted")) {
      return;
    }

    const db = admin.firestore();
    const requestRef = db.collection("booking_requests").doc(requestId);

    // Idempotency guard via transaction
    let importState;
    try {
      await db.runTransaction(async (tx) => {
        const snap = await tx.get(requestRef);
        if (!snap.exists) throw new Error("request-not-found");
        importState = snap.data().importState;
        if (importState === "processing" || importState === "done") {
          throw new Error("already-processing");
        }
        tx.update(requestRef, {
          importState: "processing",
          importProcessingStartedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
      });
    } catch (err) {
      if (String(err.message) === "already-processing") {
        logger.info("onBookingRequestAccepted: skipped (idempotent)", {requestId});
        return;
      }
      logger.error("onBookingRequestAccepted: transaction failed", {requestId, err});
      return;
    }

    try {
      await importBookingRequest(db, requestId, after);
    } catch (err) {
      // already logged and marked as failed inside importBookingRequest
    }
  },
);

// ── Recovery scheduler for stuck booking imports ──────────────────────────
// Runs every 10 minutes. Finds booking_requests stuck in importState=processing
// for more than 5 minutes (function crashed before completion) and retries import.
exports.recoverStuckBookingImports = onSchedule(
  {
    region: REGION,
    schedule: "every 10 minutes",
    timeZone: "UTC",
    memory: "256MiB",
    maxInstances: 1,
  },
  async () => {
    const db = admin.firestore();
    const stuckThresholdMs = Date.now() - 5 * 60 * 1000; // older than 5 min
    const stuckTs = admin.firestore.Timestamp.fromMillis(stuckThresholdMs);

    const snap = await db
      .collection("booking_requests")
      .where("status", "==", "accepted")
      .where("importState", "==", "processing")
      .where("importProcessingStartedAt", "<=", stuckTs)
      .limit(50)
      .get();

    if (snap.empty) {
      logger.info("recoverStuckBookingImports: nothing to recover");
      return;
    }

    logger.info("recoverStuckBookingImports: found stuck requests", {count: snap.size});

    for (const doc of snap.docs) {
      const requestId = doc.id;
      try {
        // Reset importState so importBookingRequest can proceed.
        // Do NOT update updatedAt — it would push the doc out of the stuck query window.
        await doc.ref.update({
          importState: null,
          importProcessingStartedAt: admin.firestore.FieldValue.delete(),
        });
        await importBookingRequest(db, requestId, doc.data());
        logger.info("recoverStuckBookingImports: recovered", {requestId});
      } catch (err) {
        logger.error("recoverStuckBookingImports: failed to recover", {
          requestId,
          err: String(err),
        });
      }
    }
  },
);

// ── RevenueCat Webhook ──────────────────────────────────────────────────────
// Receives subscription lifecycle events from RevenueCat and updates Firestore
// immediately, without waiting for the client to poll via syncPlanStatus.
//
// Setup in RevenueCat Dashboard → Integrations → Webhooks:
//   URL: https://<region>-<project>.cloudfunctions.net/revenueCatWebhook
//   Authorization header: Bearer <REVENUECAT_WEBHOOK_SECRET>
//   (store secret as Firebase Secret: REVENUECAT_WEBHOOK_SECRET)
//
// Handled events: INITIAL_PURCHASE, RENEWAL, CANCELLATION, EXPIRATION,
//   BILLING_ISSUE_DETECTED, PRODUCT_CHANGE
const revenueCatWebhookSecret = defineSecret("REVENUECAT_WEBHOOK_SECRET");

// ── SMS helpers ─────────────────────────────────────────────────────────────

/**
 * Sends an SMS via Twilio. Returns {success, sid?, error?}.
 * Supports any international number (+XX...) — not limited to Poland.
 */
async function sendSms(toPhone, body) {
  const accountSid = twilioAccountSid.value();
  const authToken = twilioAuthToken.value();
  const fromNumber = _twilioFromNumber();

  if (!accountSid || !authToken || !fromNumber) {
    logger.warn("sendSms: Twilio secrets not configured — skipping");
    return {success: false, error: "secrets-not-configured"};
  }

  // Lazy-require so Twilio isn't loaded unless secrets exist
  const twilio = require("twilio");
  const client = twilio(accountSid, authToken);

  try {
    const msg = await client.messages.create({
      body,
      from: fromNumber,
      to: toPhone,
    });
    return {success: true, sid: msg.sid};
  } catch (err) {
    return {success: false, error: String(err.message || err)};
  }
}

/**
 * Checks whether the org is within its SMS quota for the current billing month.
 * Returns {allowed, used, limit}.
 */
async function checkSmsQuota(db, orgId, plan) {
  const limit = SMS_PLAN_LIMITS[plan] ?? 0;
  if (limit === 0) return {allowed: false, used: 0, limit};

  const orgRef = db.collection("organizations").doc(orgId);
  const orgSnap = await orgRef.get();
  if (!orgSnap.exists) return {allowed: false, used: 0, limit};

  const used = orgSnap.data().smsSentThisMonth ?? 0;
  return {allowed: used < limit, used, limit};
}

/**
 * Atomically increments the org SMS counter and records the last send time.
 */
async function incrementSmsCounter(db, orgId) {
  await db.collection("organizations").doc(orgId).update({
    smsSentThisMonth: admin.firestore.FieldValue.increment(1),
    smsLastSentAt: admin.firestore.FieldValue.serverTimestamp(),
  });
}

// ── Distributed lock helpers ─────────────────────────────────────────────────
// Prevents duplicate execution when Cloud Run spins up multiple instances of
// the same scheduled function simultaneously. Uses a Firestore document as a
// mutex: acquire → run → release. Lock expires after maxAgeMs automatically.

const LOCK_MAX_AGE_MS = 4 * 60 * 1000; // 4 min — shorter than every-5-min cadence

/**
 * Try to acquire a named lock. Returns true if acquired, false if already held.
 */
async function acquireLock(db, lockName) {
  const lockRef = db.collection("scheduler_locks").doc(lockName);
  try {
    await db.runTransaction(async (tx) => {
      const snap = await tx.get(lockRef);
      if (snap.exists) {
        const acquiredMs = snap.data().acquiredAt
          ? snap.data().acquiredAt.toMillis()
          : 0;
        if (Date.now() - acquiredMs < LOCK_MAX_AGE_MS) {
          throw new Error("lock-held");
        }
      }
      tx.set(lockRef, {
        acquiredAt: admin.firestore.FieldValue.serverTimestamp(),
        acquiredBy: process.env.K_REVISION || "unknown",
      });
    });
    return true;
  } catch (err) {
    if (String(err.message) === "lock-held") return false;
    throw err;
  }
}

async function releaseLock(db, lockName) {
  await db.collection("scheduler_locks").doc(lockName).delete().catch(() => {});
}

// ── Appointment SMS reminder scheduler ──────────────────────────────────────
// Runs every 5 minutes. Scans all orgs for upcoming appointments and sends
// SMS reminders at the 24h and 2h marks. Works for any country/phone format.
exports.sendAppointmentSmsReminders = onSchedule(
  {
    region: REGION,
    schedule: "every 5 minutes",
    timeZone: "UTC",
    memory: "512MiB",
    maxInstances: 1,
    secrets: [twilioAccountSid, twilioAuthToken],
  },
  async () => {
    const db = admin.firestore();
    if (!await acquireLock(db, "smsReminders")) {
      logger.info("sendAppointmentSmsReminders: lock held by another instance, skipping");
      return;
    }
    try {
    const nowMs = Date.now();

    // Iterate over windows (24h, 2h)
    for (const window of SMS_WINDOWS) {
      const orgCache = new Map(); // orgId -> orgData
      const clientCache = new Map(); // `${orgId}/${clientId}` -> clientData
      const windowStart = nowMs + window.leadMs - window.windowMs;
      const windowEnd   = nowMs + window.leadMs + window.windowMs;

      const windowStartTs = admin.firestore.Timestamp.fromMillis(windowStart);
      const windowEndTs   = admin.firestore.Timestamp.fromMillis(windowEnd);

      // Paginated collectionGroup scan — 200 docs per page to prevent timeout.
      let lastDoc = null;
      let pageHasMore = true;
      while (pageHasMore) {
        let query = db
          .collectionGroup("orders")
          .where("scheduledDate", ">=", windowStartTs)
          .where("scheduledDate", "<=", windowEndTs)
          .where("status", "in", ["scheduled", "inProgress"])
          .orderBy("scheduledDate")
          .limit(SCHEDULER_PAGE_SIZE);
        if (lastDoc) query = query.startAfter(lastDoc);

        const ordersSnap = await query.get();
        if (ordersSnap.empty) break;

        for (const orderDoc of ordersSnap.docs) {
          const order = orderDoc.data();

          // Skip if already sent this window
          if (order[window.field]) continue;

          // Extract orgId from path: organizations/{orgId}/orders/{orderId}
          const pathParts = orderDoc.ref.path.split("/");
          const orgId = pathParts[1];

          // Resolve client phone
          const clientId = order.clientId;
          if (!clientId) continue;

          const clientCacheKey = `${orgId}/${clientId}`;
          let clientData = clientCache.get(clientCacheKey);
          if (!clientData) {
            const clientSnap = await db
              .collection(`organizations/${orgId}/clients`)
              .doc(clientId)
              .get();
            if (!clientSnap.exists) continue;
            clientData = clientSnap.data();
            clientCache.set(clientCacheKey, clientData);
          }
          const phone = clientData.phone;
          if (!phone || phone.length < 7) continue;

          // Resolve org plan
          let orgData = orgCache.get(orgId);
          if (!orgData) {
            const orgSnap = await db.collection("organizations").doc(orgId).get();
            if (!orgSnap.exists) continue;
            orgData = orgSnap.data();
            orgCache.set(orgId, orgData);
          }
          const orgPlan = orgData.plan ?? "free";

          // Check quota inline
          const smsLimit = SMS_PLAN_LIMITS[orgPlan] ?? 0;
          if (smsLimit === 0) continue;
          const smsUsed = orgData.smsSentThisMonth ?? 0;
          if (smsUsed >= smsLimit) {
            logger.info("sendAppointmentSmsReminders: quota exceeded", { orgId, window: window.label, used: smsUsed, limit: smsLimit });
            continue;
          }

          // Build message
          const clientName  = order.client || clientData.name || "";
          const serviceName = order.service || "";
          const timeLabel   = order.scheduledTime || "";
          const dateTs      = order.scheduledDate?.toDate?.() ?? new Date();
          const dateStr     = `${String(dateTs.getDate()).padStart(2, "0")}.${String(dateTs.getMonth() + 1).padStart(2, "0")}`;

          const leadLabel = window.label === "24h" ? "tomorrow" : "in 2 hours";
          const smsBody = serviceName
            ? `Hi ${clientName}! Reminder: your ${serviceName} appointment is ${leadLabel} at ${timeLabel} (${dateStr}). Reply STOP to unsubscribe.`
            : `Hi ${clientName}! Reminder: your detailing appointment is ${leadLabel} at ${timeLabel} (${dateStr}). Reply STOP to unsubscribe.`;

          // Send
          const result = await sendSms(phone, smsBody);

          if (result.success) {
            await orderDoc.ref.update({
              [window.field]: admin.firestore.FieldValue.serverTimestamp(),
              smsLastStatus: "sent",
              smsLastError: null,
              smsLastSid: result.sid ?? null,
            });
            await incrementSmsCounter(db, orgId);
            if (orgCache.has(orgId)) {
              const cached = orgCache.get(orgId);
              cached.smsSentThisMonth = (cached.smsSentThisMonth ?? 0) + 1;
            }
            logger.info("sendAppointmentSmsReminders: sent", {
              orderId: orderDoc.id, orgId, window: window.label, sid: result.sid,
            });
          } else {
            const retryKey = `${window.field}_retryCount`;
            const currentRetryCount = (order[retryKey] ?? 0);
            const updateData = {
              smsLastStatus: "failed",
              smsLastError: result.error ?? null,
              [retryKey]: currentRetryCount + 1,
            };
            // Close the window only after 3 failed attempts to prevent retry storm
            if (currentRetryCount >= 2) {
              updateData[window.field] = admin.firestore.FieldValue.serverTimestamp();
            }
            await orderDoc.ref.update(updateData);
            logger.warn("sendAppointmentSmsReminders: failed", {
              orderId: orderDoc.id, orgId, window: window.label,
              error: result.error, retryCount: currentRetryCount + 1,
            });
          }
        }

        if (ordersSnap.size < SCHEDULER_PAGE_SIZE) {
          pageHasMore = false;
        } else {
          lastDoc = ordersSnap.docs[ordersSnap.docs.length - 1];
        }
      }
    }
    } finally {
      await releaseLock(db, "smsReminders");
    }
  },
);

// ── Monthly SMS counter reset ─────────────────────────────────────────────────
// Runs on 1st of every month at 00:05 UTC. Resets smsSentThisMonth for all orgs.
exports.resetMonthlySmsCounters = onSchedule(
  {
    region: REGION,
    schedule: "5 0 1 * *",
    timeZone: "UTC",
    memory: "256MiB",
    maxInstances: 1,
  },
  async () => {
    const db = admin.firestore();
    const snap = await db.collection("organizations").get();
    if (snap.empty) return;

    const BATCH_SIZE = 400;
    let count = 0;
    let batch = db.batch();

    for (const doc of snap.docs) {
      batch.update(doc.ref, {
        smsSentThisMonth: 0,
        smsResetAt: admin.firestore.FieldValue.serverTimestamp(),
      });
      count++;
      if (count % BATCH_SIZE === 0) {
        await batch.commit();
        batch = db.batch();
      }
    }
    if (count % BATCH_SIZE !== 0) await batch.commit();

    logger.info("resetMonthlySmsCounters: done", {orgsReset: count});
  },
);

// ── Email helpers ────────────────────────────────────────────────────────────

/**
 * Sends a transactional email via Resend. Returns {success, id?, error?}.
 * @param {string} to - recipient email address
 * @param {string} subject - email subject
 * @param {string} html - email HTML body
 */
async function sendEmail(to, subject, html) {
  const apiKey = resendApiKey.value();
  if (!apiKey) {
    logger.warn("sendEmail: RESEND_API_KEY not configured — skipping");
    return {success: false, error: "api-key-not-configured"};
  }

  // Lazy-require so Resend isn't loaded unless the secret exists
  const {Resend} = require("resend");
  const resend = new Resend(apiKey);

  try {
    const {data, error} = await resend.emails.send({
      from: "DetailingPro <reminders@detailing-pro.app>",
      to,
      subject,
      html,
    });
    if (error) return {success: false, error: String(error.message || error)};
    return {success: true, id: data.id};
  } catch (err) {
    return {success: false, error: String(err.message || err)};
  }
}

/**
 * Checks whether the org is within its email quota for the current billing month.
 */
async function checkEmailQuota(db, orgId, plan) {
  const limit = EMAIL_PLAN_LIMITS[plan] ?? 0;
  if (limit === 0) return {allowed: false, used: 0, limit};

  const orgSnap = await db.collection("organizations").doc(orgId).get();
  if (!orgSnap.exists) return {allowed: false, used: 0, limit};

  const used = orgSnap.data().emailSentThisMonth ?? 0;
  return {allowed: used < limit, used, limit};
}

async function incrementEmailCounter(db, orgId) {
  await db.collection("organizations").doc(orgId).update({
    emailSentThisMonth: admin.firestore.FieldValue.increment(1),
    emailLastSentAt: admin.firestore.FieldValue.serverTimestamp(),
  });
}

// ── Appointment email reminder scheduler ────────────────────────────────────
// Runs every 5 minutes (same cadence as SMS). Sends reminder emails at 24h and
// 2h marks to any client with an email on file.
exports.sendAppointmentEmailReminders = onSchedule(
  {
    region: REGION,
    schedule: "every 5 minutes",
    timeZone: "UTC",
    memory: "512MiB",
    maxInstances: 1,
    secrets: [resendApiKey],
  },
  async () => {
    const db = admin.firestore();
    if (!await acquireLock(db, "emailReminders")) {
      logger.info("sendAppointmentEmailReminders: lock held by another instance, skipping");
      return;
    }
    try {
    const nowMs = Date.now();

    for (const window of EMAIL_WINDOWS) {
      const orgCache = new Map(); // orgId -> orgData
      const clientCache = new Map(); // `${orgId}/${clientId}` -> clientData
      const windowStart = nowMs + window.leadMs - window.windowMs;
      const windowEnd   = nowMs + window.leadMs + window.windowMs;
      const windowStartTs = admin.firestore.Timestamp.fromMillis(windowStart);
      const windowEndTs   = admin.firestore.Timestamp.fromMillis(windowEnd);

      // Paginated collectionGroup scan — 200 docs per page to prevent timeout.
      let lastDoc = null;
      let pageHasMore = true;
      while (pageHasMore) {
        let query = db
          .collectionGroup("orders")
          .where("scheduledDate", ">=", windowStartTs)
          .where("scheduledDate", "<=", windowEndTs)
          .where("status", "in", ["scheduled", "inProgress"])
          .orderBy("scheduledDate")
          .limit(SCHEDULER_PAGE_SIZE);
        if (lastDoc) query = query.startAfter(lastDoc);

        const ordersSnap = await query.get();
        if (ordersSnap.empty) break;

        for (const orderDoc of ordersSnap.docs) {
          const order = orderDoc.data();
          if (order[window.field]) continue;

          const pathParts = orderDoc.ref.path.split("/");
          const orgId = pathParts[1];

          const clientId = order.clientId;
          if (!clientId) continue;

          const clientCacheKey = `${orgId}/${clientId}`;
          let clientData = clientCache.get(clientCacheKey);
          if (!clientData) {
            const clientSnap = await db
              .collection(`organizations/${orgId}/clients`)
              .doc(clientId)
              .get();
            if (!clientSnap.exists) continue;
            clientData = clientSnap.data();
            clientCache.set(clientCacheKey, clientData);
          }
          const email = clientData.email;
          if (!email || !email.includes("@")) continue;

          let orgData = orgCache.get(orgId);
          if (!orgData) {
            const orgSnap = await db.collection("organizations").doc(orgId).get();
            if (!orgSnap.exists) continue;
            orgData = orgSnap.data();
            orgCache.set(orgId, orgData);
          }
          const orgPlan = orgData.plan ?? "free";
          const orgName = orgData.name || "DetailingPro";

          // Check quota inline
          const emailLimit = EMAIL_PLAN_LIMITS[orgPlan] ?? 0;
          if (emailLimit === 0) continue;
          const emailUsed = orgData.emailSentThisMonth ?? 0;
          if (emailUsed >= emailLimit) {
            logger.info("sendAppointmentEmailReminders: quota exceeded", { orgId, window: window.label, used: emailUsed, limit: emailLimit });
            continue;
          }

          const clientName  = escapeHtml(order.client || clientData.name || "");
          const serviceName = escapeHtml(order.service || "");
          const timeLabel   = escapeHtml(order.scheduledTime || "");
          const orgNameSafe = escapeHtml(orgName);
          const dateTs      = order.scheduledDate?.toDate?.() ?? new Date();
          const dateStr     = `${String(dateTs.getDate()).padStart(2, "0")}.${String(dateTs.getMonth() + 1).padStart(2, "0")}.${dateTs.getFullYear()}`;

          const leadLabel = window.label === "24h" ? "tomorrow" : "in 2 hours";
          const subject = `Reminder: your appointment is ${leadLabel}`;
          const html = `
<div style="font-family:sans-serif;max-width:520px;margin:0 auto;padding:24px;background:#f9f9f9;border-radius:12px">
  <h2 style="color:#1a1a1a">Hi ${clientName}! 👋</h2>
  <p style="font-size:16px;color:#333">
    This is a reminder that your <strong>${serviceName || "detailing"}</strong> appointment
    is <strong>${leadLabel}</strong>.
  </p>
  <table style="width:100%;border-collapse:collapse;margin:16px 0">
    <tr>
      <td style="padding:8px 12px;background:#fff;border-radius:8px 8px 0 0;border-bottom:1px solid #eee;color:#888;font-size:13px">Date</td>
      <td style="padding:8px 12px;background:#fff;border-radius:8px 8px 0 0;border-bottom:1px solid #eee;font-weight:600">${dateStr}</td>
    </tr>
    <tr>
      <td style="padding:8px 12px;background:#fff;color:#888;font-size:13px">Time</td>
      <td style="padding:8px 12px;background:#fff;font-weight:600">${timeLabel}</td>
    </tr>
    ${serviceName ? `<tr><td style="padding:8px 12px;background:#fff;border-radius:0 0 8px 8px;color:#888;font-size:13px">Service</td><td style="padding:8px 12px;background:#fff;border-radius:0 0 8px 8px;font-weight:600">${serviceName}</td></tr>` : ""}
  </table>
  <p style="color:#666;font-size:13px;margin-top:24px">See you soon! — <strong>${orgNameSafe}</strong></p>
  <p style="color:#aaa;font-size:11px;margin-top:8px">To unsubscribe from reminders, contact your service provider.</p>
</div>`;

          const result = await sendEmail(email, subject, html);

          if (result.success) {
            await orderDoc.ref.update({
              [window.field]: admin.firestore.FieldValue.serverTimestamp(),
              emailLastStatus: "sent",
              emailLastError: null,
              emailLastId: result.id ?? null,
            });
            await incrementEmailCounter(db, orgId);
            if (orgCache.has(orgId)) {
              const cached = orgCache.get(orgId);
              cached.emailSentThisMonth = (cached.emailSentThisMonth ?? 0) + 1;
            }
            logger.info("sendAppointmentEmailReminders: sent", {
              orderId: orderDoc.id, orgId, window: window.label, id: result.id,
            });
          } else {
            const retryKey = `${window.field}_retryCount`;
            const currentRetryCount = (order[retryKey] ?? 0);
            const updateData = {
              emailLastStatus: "failed",
              emailLastError: result.error ?? null,
              [retryKey]: currentRetryCount + 1,
            };
            // Close the window only after 3 failed attempts to prevent retry storm
            if (currentRetryCount >= 2) {
              updateData[window.field] = admin.firestore.FieldValue.serverTimestamp();
            }
            await orderDoc.ref.update(updateData);
            logger.warn("sendAppointmentEmailReminders: failed", {
              orderId: orderDoc.id, orgId, window: window.label,
              error: result.error, retryCount: currentRetryCount + 1,
            });
          }
        }

        if (ordersSnap.size < SCHEDULER_PAGE_SIZE) {
          pageHasMore = false;
        } else {
          lastDoc = ordersSnap.docs[ordersSnap.docs.length - 1];
        }
      }
    }
    } finally {
      await releaseLock(db, "emailReminders");
    }
  },
);

// ── Monthly email counter reset ───────────────────────────────────────────────
exports.resetMonthlyEmailCounters = onSchedule(
  {
    region: REGION,
    schedule: "5 0 1 * *",
    timeZone: "UTC",
    memory: "256MiB",
    maxInstances: 1,
  },
  async () => {
    const db = admin.firestore();
    const snap = await db.collection("organizations").get();
    if (snap.empty) return;

    const BATCH_SIZE = 400;
    let count = 0;
    let batch = db.batch();
    for (const doc of snap.docs) {
      batch.update(doc.ref, {
        emailSentThisMonth: 0,
        emailResetAt: admin.firestore.FieldValue.serverTimestamp(),
      });
      count++;
      if (count % BATCH_SIZE === 0) {
        await batch.commit();
        batch = db.batch();
      }
    }
    if (count % BATCH_SIZE !== 0) await batch.commit();

    logger.info("resetMonthlyEmailCounters: done", {orgsReset: count});
  },
);

exports.revenueCatWebhook = onRequest(
  {
    region: REGION,
    memory: "256MiB",
    maxInstances: 10,
    invoker: "public",
    secrets: [revenueCatWebhookSecret, revenueCatSecret],
  },
  async (req, res) => {
    if (req.method !== "POST") {
      res.status(405).json({error: "method-not-allowed"});
      return;
    }

    // Verify Authorization header matches our shared secret
    const expectedSecret = String(revenueCatWebhookSecret.value() || "").trim();
    if (!expectedSecret) {
      logger.error("revenueCatWebhook: REVENUECAT_WEBHOOK_SECRET not configured — rejecting request");
      res.status(503).json({ error: "webhook-secret-not-configured" });
      return;
    }
    const authHeader = String(req.headers.authorization || "");
    const providedSecret = authHeader.toLowerCase().startsWith("bearer ")
      ? authHeader.substring(7).trim()
      : "";
    if (!providedSecret || providedSecret !== expectedSecret) {
      logger.warn("revenueCatWebhook: unauthorized request");
      res.status(401).json({ error: "unauthorized" });
      return;
    }

    let event;
    try {
      event = req.body && typeof req.body === "object"
        ? req.body
        : JSON.parse(String(req.body || "{}"));
    } catch {
      res.status(400).json({error: "invalid-json"});
      return;
    }

    const eventType = String(event.event && event.event.type || "").toUpperCase();
    const appUserId = String(event.event && event.event.app_user_id || "").trim();

    if (!appUserId) {
      res.status(200).json({ok: true, skipped: "no-app-user-id"});
      return;
    }

    // Events that should update plan status
    const HANDLED_EVENTS = new Set([
      "INITIAL_PURCHASE",
      "RENEWAL",
      "CANCELLATION",
      "EXPIRATION",
      "BILLING_ISSUE_DETECTED",
      "PRODUCT_CHANGE",
      "SUBSCRIBER_ALIAS",
    ]);

    if (!HANDLED_EVENTS.has(eventType)) {
      res.status(200).json({ok: true, skipped: "unhandled-event-type", eventType});
      return;
    }

    try {
      const firestore = admin.firestore();
      const userRef = firestore.collection("users").doc(appUserId);
      const userSnap = await userRef.get();

      if (!userSnap.exists) {
        logger.warn("revenueCatWebhook: user not found", {appUserId, eventType});
        res.status(200).json({ok: true, skipped: "user-not-found"});
        return;
      }

      const userData = userSnap.data() || {};

      // Derive plan from the webhook event entitlements if present,
      // otherwise fall back to fetching fresh from RevenueCat API.
      const rcApiKey = String(revenueCatSecret.value() || "").trim();
      if (!rcApiKey) {
        logger.error("revenueCatWebhook: REVENUECAT_SECRET_KEY not configured — skipping plan update");
        res.status(503).json({ error: "rc-api-key-not-configured" });
        return;
      }
      const rcResponse = await fetch(
        `https://api.revenuecat.com/v1/subscribers/${encodeURIComponent(appUserId)}`,
        {
          method: "GET",
          headers: {
            Authorization: `Bearer ${rcApiKey}`,
            "Content-Type": "application/json",
          },
        },
      );

      let resolved;
      if (rcResponse.ok) {
        const rcPayload = await rcResponse.json();
        const subscriber = rcPayload && rcPayload.subscriber ? rcPayload.subscriber : null;
        resolved = resolvePlanFromSubscriber(subscriber);
      } else {
        logger.error("revenueCatWebhook: RC API fetch failed", {
          status: rcResponse.status,
          appUserId,
          eventType,
        });
        // Still respond 200 so RevenueCat doesn't retry indefinitely
        res.status(200).json({ok: true, error: "rc-api-failed"});
        return;
      }

      const seatLimit = resolved.plan === "business" ? 5 : 1;
      const orgId = userData.orgId;
      const previousPlan = String(userData.plan || "free");
      const previousStatus = String(userData.planStatus || "inactive");
      const previousProvider = String(userData.billingProvider || "unknown");

      const batch = firestore.batch();
      batch.set(
        userRef,
        {
          plan: resolved.plan,
          planStatus: resolved.planStatus,
          billingProvider: resolved.billingProvider,
          lastPlanSyncAt: admin.firestore.FieldValue.serverTimestamp(),
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        },
        {merge: true},
      );

      if (typeof orgId === "string" && orgId.trim().length > 0) {
        batch.set(
          firestore.collection("organizations").doc(orgId),
          {
            plan: resolved.plan,
            planStatus: resolved.planStatus,
            billingProvider: resolved.billingProvider,
            seatLimit,
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
          },
          {merge: true},
        );
      }

      const changed =
        previousPlan !== resolved.plan ||
        previousStatus !== resolved.planStatus ||
        previousProvider !== resolved.billingProvider;

      if (changed) {
        const auditRef = firestore.collection("billing_audit").doc();
        batch.set(auditRef, {
          uid: appUserId,
          orgId: typeof orgId === "string" ? orgId : null,
          source: `webhook:${eventType}`,
          previous: {
            plan: previousPlan,
            planStatus: previousStatus,
            billingProvider: previousProvider,
          },
          current: {
            plan: resolved.plan,
            planStatus: resolved.planStatus,
            billingProvider: resolved.billingProvider,
          },
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();

      logger.info("revenueCatWebhook: plan updated", {
        appUserId,
        eventType,
        plan: resolved.plan,
        planStatus: resolved.planStatus,
        changed,
      });

      res.status(200).json({
        ok: true,
        plan: resolved.plan,
        planStatus: resolved.planStatus,
      });
    } catch (error) {
      logger.error("revenueCatWebhook: failed", {appUserId, eventType, error: String(error)});
      // Return 500 so RevenueCat will retry
      res.status(500).json({error: "internal"});
    }
  },
);
