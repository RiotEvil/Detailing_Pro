# Google Play Market Publish Checklist

## Project: DetailingPro Business Management App

## Market: Poland (Primary), Multi-language support

## ✅ Release v22 Snapshot (2026-05-20)

- [x] Version updated to 7.1.4+22 in pubspec.yaml
- [x] Signed AAB built: build/app/outputs/bundle/release/app-release.aab
- [x] Firestore rules deployed
- [x] Cloud Functions deployed
- [x] Smoke checks green: functionsHealth=200, getBookingAvailability(no masterUid)=400, createBookingRequest(invalid payload)=400
- [x] Release notes prepared for 10 locales
- [ ] Final manual check on physical Android device
- [ ] Upload AAB to Google Play and start staged rollout

---

## ✅ COMPLETED - Week 1 (Security & Input Validation)

### 1. Firestore Security Rules Hardening

- [x] User role escalation fixed (cannot modify `role`/`orgId` directly)
- [x] Invite code tampering prevention (only `used`, `usedBy`, `usedAt` changeable)
- [x] Chat room creator must be participant
- [x] Booking requests validation + field whitelist + length limits
- [x] `app_config` collection: public read (ForceUpdate), write blocked

### 2. Hive Storage Encryption

- [x] flutter_secure_storage integrated
- [x] AES-256 cipher with OS keystore
- [x] Auto-migration from unencrypted legacy data
- [x] Sensitive boxes encrypted: settings, clients, orders, finance, vehicles

### 3. Input Validation

- [x] Phone number validation (7-15 digits, +/- format allowed)
- [x] Service name required + price >= 0
- [x] L10n keys added to all 9 languages

### 4. Version & Signing

- [x] Updated version to 1.0.0+1 (first Play Market release)
- [x] Keystore configured (key.properties in .gitignore ✓)
- [x] Signing config: release build signs with keystore

---

## ✅ IN-PROGRESS/DONE - Play Market Preparation

### 5. OAuth & Secrets

- [x] Google OAuth Client ID extracted to `lib/core/oauth_config.dart`
- [x] Added TODO comment: for production, fetch from backend
- [x] auth_screen.dart updated to use config
- [x] Removed hardcoded Client ID

### 6. Debug Cleanup

- [x] debugPrint disabled in release mode (kReleaseMode check)
- [x] AndroidManifest.xml verified (INTERNET, CAMERA, POST_NOTIFICATIONS)
- [x] Debug banner already disabled

### 7. Gradle & Minification

- [x] Release build: isMinifyEnabled = true
- [x] Release build: isShrinkResources = true
- [x] proguard-rules.pro updated (correct package: com.detailing.business.app)
- [x] Java 17 desugaring enabled
- [x] gradle.properties optimized for Windows

### 8. Production Settings

- [x] Application ID: com.detailing.business.app ✓
- [x] **Namespace: com.detailing.business.app** (fixed from com.example.flutter_application_1)
- [x] **MainActivity.kt moved to com/detailing/business/app/** (fixed)
- [x] Min SDK: **21** (explicit, not flutter.minSdkVersion)
- [x] Target SDK: depends on flutter.targetSdkVersion

### 9. Security Hardening (App Council Review — April 2026)

- [x] **CORS in Cloud Functions**: restricted to Firebase Hosting domains only (fixed wildcard `*`)
- [x] **Storage rules**: 10 MB file size limit added on write
- [x] **INTERNET permission**: explicitly declared in AndroidManifest.xml

---

## 📋 TODO - Store Listing & Metadata

### 9. Google Play Console Setup

- [ ] Create app listing in Google Play Console
- [ ] App name: "DetailingPro" or "Detailing Pro Business"
- [ ] Category: Business / Tools
- [ ] Content rating questionnaire
- [ ] Privacy policy URL (finalize legal/legalTermsSummaryTitle)
- [ ] Target audience: Professional/Business users (not children)

### 10. App Listing Content

- [ ] Short description (80 chars max)
- [ ] Full description (4000 chars max, include all 9 language translations)
- [ ] Screenshots (2-8 per language, show key features)
- [ ] Feature graphic (1024x500px)
- [ ] App icon (512x512px, already present in assets)

### 11. Pricing & Distribution

- [ ] Pricing strategy: Free / In-app purchases / Paid subscription
- [ ] Market listing countries (at least Poland for PLN market)
- [ ] Release track: Beta (internal testing first) → Production

### 12. Legal & Compliance

- [x] Privacy policy reviewed and finalized
  - Published: https://detailing-pro.web.app/privacy-policy.html
- [x] Terms of service finalized
  - Lume Studio Vladyslav Krasnikov, Poland jurisdiction, April 27 2026
- [x] Both policies uploaded to public URLs

### 13. App Signing

- [x] Generate APK or AAB for testing
  - Built: build\app\outputs\bundle\release\app-release.aab (7.1.4+22)
- [ ] Test on actual device or emulator
- [ ] Verify Firebase initialization
- [ ] Verify Google Sign-In works

### 14. Testing Before Upload

- [ ] Test auth flow (email/password, Google, guest, invite code)
- [ ] Test core features (CRUD clients, orders, services)
- [ ] Test Firestore sync online/offline
- [ ] Test notifications (FCM push notifications)
- [ ] Test on multiple Android versions (min SDK to latest)
- [ ] Memory/performance profiling

### 15. Upload to Google Play

- [x] Build finalized release AAB (7.1.4+22)
- [ ] Upload v22 bundle to production track
- [ ] Add v22 release notes in all 10 locales
- [ ] Start staged rollout (5% -> 25% -> 100%)
- [x] Baseline: app already published and active since April 27, 2026

---

## 🔐 Security Checklist

- [x] API keys in firebase_options.dart (acceptable - Firebase-bound by default)
- [x] OAuth Client ID externalized
- [x] keystore passwords in .gitignore
- [x] Firestore Security Rules enforced
- [x] Hive storage encrypted
- [x] Debug info stripped in release build

---

## 📊 Configuration Summary

**App**: DetailingPro (com.detailing.business.app)  
**Version**: 7.1.4 (build 22)
**Min SDK**: 21
**Target SDK**: flutter.targetSdkVersion (typically 34+)
**Signing**: android/app/upload-keystore.jks  
**Locales**: 10 (en, pl, ru, uk, de, es, it, pt, tr, zh)
**Permissions**: CAMERA, POST_NOTIFICATIONS, READ_MEDIA_IMAGES, READ_EXTERNAL_STORAGE

---

## 🚀 Next Steps

1. **Test Build with RevenueCat key** (required for paid plans):

   ```bash
   flutter build appbundle --release \
     --dart-define=RC_ANDROID_API_KEY=appl_YOUR_ANDROID_KEY_HERE
   ```

   > Store `RC_ANDROID_API_KEY` in CI/CD secrets (GitHub Actions: Settings → Secrets).
   > Never commit to source control. For local builds, create `build_config.env` (gitignored):
   >
   > ```
   > RC_ANDROID_API_KEY=appl_...
   > ```
   >
   > Then build via: `flutter build appbundle --release --dart-define-from-file=build_config.env`

2. **Create Firestore `app_config/versions` document** for ForceUpdate:

   ```json
   {
     "minAndroid": "1.0.0",
     "minAndroidBuild": 1,
     "androidUrl": "https://play.google.com/store/apps/details?id=com.detailing.business.app"
   }
   ```

3. **Deploy Cloud Functions** (CORS fix applies):

   ```bash
   cd functions && firebase deploy --only functions
   ```

4. **Deploy Firestore + Storage rules**:

   ```bash
   firebase deploy --only firestore,storage
   ```

5. **Manual QA**: Install on device, test all features

6. **Google Play Console**: Create app listing, upload AAB

7. **Legal Finalization**: Review and post privacy policy/terms

8. **Soft Launch**: Beta track with testers

9. **Production Release**: Staged rollout starting at 5%
