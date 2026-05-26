import 'dart:convert';
import 'dart:async';
import 'dart:io' show ContentType, HttpClient, HttpHeaders;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'constants.dart';

class CloudProfileSync {
  CloudProfileSync._();

  static const String _functionsRegion = 'europe-west3';

  static bool get _firebaseReady => Firebase.apps.isNotEmpty;

  static Future<void> ensureUserProfile({String? fallbackName}) async {
    if (!_firebaseReady) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    final users = FirebaseFirestore.instance.collection('users');
    await users.doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName ?? fallbackName ?? user.email ?? 'user',
      'updatedAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    final normalizedName =
        (user.displayName ?? fallbackName ?? user.email ?? 'user')
            .trim()
            .toLowerCase();
    await FirebaseFirestore.instance
        .collection('public_users')
        .doc(user.uid)
        .set({
          'uid': user.uid,
          'displayName':
              user.displayName ?? fallbackName ?? user.email ?? 'user',
          'searchName': normalizedName,
          // Keep previously leaked fields removed when merging profile updates.
          'email': FieldValue.delete(),
          'searchEmail': FieldValue.delete(),
          'updatedAt': FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

    await ensurePlanDefaults();
  }

  static Future<void> syncBusinessMode(BusinessMode mode) async {
    if (!_firebaseReady) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    final orgId = 'org_${user.uid}';

    // Sensitive access fields are written only via Admin SDK Cloud Function.
    await _callSetBusinessMode(user, mode);

    await ensurePlanDefaults(orgId: orgId);
  }

  /// Calls the `setBusinessMode` Cloud Function to write privilege-sensitive
  /// fields (`orgId`, `role`, `businessMode`) to `users` and `public_users`.
  static Future<void> _callSetBusinessMode(User user, BusinessMode mode) async {
    final projectId = Firebase.app().options.projectId;
    if (projectId.isEmpty) {
      throw Exception('setBusinessMode failed: missing projectId');
    }

    final idToken = await user.getIdToken();
    if (idToken == null || idToken.isEmpty) {
      throw Exception('setBusinessMode failed: missing idToken');
    }

    final uri = Uri.parse(
      'https://$_functionsRegion-$projectId.cloudfunctions.net/setBusinessMode',
    );
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 15);

    try {
      final request = await client.postUrl(uri);
      request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $idToken');
      request.headers.contentType = ContentType.json;
      request.add(utf8.encode(jsonEncode({'mode': mode.name})));

      final response = await request.close().timeout(
        const Duration(seconds: 15),
      );
      final body = await utf8.decoder.bind(response).join();

      if (response.statusCode != 200) {
        throw Exception('setBusinessMode failed: ${response.statusCode} $body');
      }
    } catch (e) {
      rethrow;
    } finally {
      client.close(force: true);
    }
  }

  static Future<void> syncRole(AppRole role) async {
    // Role is set via the setBusinessMode Cloud Function (Admin SDK).
    // Direct client writes of `role` are intentionally omitted to prevent
    // privilege escalation. This method is kept for API compatibility only.
  }

  static Future<void> ensurePlanDefaults({String? orgId}) async {
    if (!_firebaseReady) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    final firestore = FirebaseFirestore.instance;
    final users = firestore.collection('users');
    final userRef = users.doc(user.uid);
    final userSnap = await userRef.get();
    final userData = userSnap.data() ?? <String, dynamic>{};

    final userUpdates = <String, dynamic>{};
    if ((userData['plan']?.toString() ?? '').isEmpty) {
      userUpdates['plan'] = AppPlan.free.name;
    }
    if ((userData['planStatus']?.toString() ?? '').isEmpty) {
      userUpdates['planStatus'] = PlanStatus.inactive.name;
    }
    if ((userData['billingProvider']?.toString() ?? '').isEmpty) {
      userUpdates['billingProvider'] = 'manual';
    }
    if (userUpdates.isNotEmpty) {
      userUpdates['updatedAt'] = FieldValue.serverTimestamp();
      try {
        await userRef.set(userUpdates, SetOptions(merge: true));
      } catch (e) {
        // Billing fields may be backend-managed by Firestore rules.
        debugPrint('Failed to set user billing defaults: $e');
      }
    }

    final effectiveOrgId = orgId ?? userData['orgId']?.toString();
    if (effectiveOrgId == null || effectiveOrgId.isEmpty) {
      return;
    }

    final orgRef = firestore.collection('organizations').doc(effectiveOrgId);
    final orgSnap = await orgRef.get();
    final orgData = orgSnap.data() ?? <String, dynamic>{};
    final orgUpdates = <String, dynamic>{};
    if ((orgData['plan']?.toString() ?? '').isEmpty) {
      orgUpdates['plan'] = AppPlan.free.name;
    }
    if ((orgData['planStatus']?.toString() ?? '').isEmpty) {
      orgUpdates['planStatus'] = PlanStatus.inactive.name;
    }
    if (orgData['seatLimit'] == null) {
      orgUpdates['seatLimit'] = 1;
    }
    if (orgUpdates.isNotEmpty) {
      orgUpdates['updatedAt'] = FieldValue.serverTimestamp();
      try {
        await orgRef.set(orgUpdates, SetOptions(merge: true));
      } catch (e) {
        // Organization billing defaults are optional on client side.
        debugPrint('Failed to set org billing defaults: $e');
      }
    }
  }

  static Future<void> syncPlanSelection({
    required AppPlan plan,
    PlanStatus status = PlanStatus.active,
    String billingProvider = 'manual',
  }) async {
    // Deprecated: billing synchronization should be performed only via
    // backend function after server-side entitlement validation.
    return;
  }

  static Future<Map<String, String>?> fetchAccessProfile() async {
    if (!_firebaseReady) {
      return null;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }

    final userSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final userData = userSnap.data();
    if (userData == null) {
      return null;
    }

    Map<String, dynamic>? orgData;
    final orgId = userData['orgId']?.toString();
    if (orgId != null && orgId.isNotEmpty) {
      final orgSnap = await FirebaseFirestore.instance
          .collection('organizations')
          .doc(orgId)
          .get();
      orgData = orgSnap.data();
    }

    return _composeAccessProfile(userData, orgData);
  }

  static Stream<Map<String, String>> watchAccessProfile() {
    if (!_firebaseReady) {
      return const Stream<Map<String, String>>.empty();
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Stream<Map<String, String>>.empty();
    }

    // Manual switchMap: cancel the org subscription only when orgId changes,
    // preventing stale Firestore listener accumulation.
    final controller = StreamController<Map<String, String>>();
    StreamSubscription<dynamic>? orgSub;
    String? trackedOrgId;
    Map<String, dynamic>? latestUserData;
    Map<String, dynamic>? latestOrgData;

    final userSub = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .listen(
          (userSnap) {
            latestUserData = userSnap.data();
            if (latestUserData == null) {
              controller.add(<String, String>{});
              return;
            }
            final orgId = latestUserData!['orgId']?.toString();
            if (orgId == null || orgId.isEmpty) {
              orgSub?.cancel();
              orgSub = null;
              trackedOrgId = null;
              latestOrgData = null;
              controller.add(_composeAccessProfile(latestUserData!, null));
              return;
            }
            if (orgId == trackedOrgId) {
              // orgId unchanged — emit with cached org data in case user fields changed.
              controller.add(_composeAccessProfile(latestUserData!, latestOrgData));
              return;
            }
            // orgId changed — cancel previous org listener and start fresh.
            orgSub?.cancel();
            trackedOrgId = orgId;
            latestOrgData = null;
            orgSub = FirebaseFirestore.instance
                .collection('organizations')
                .doc(orgId)
                .snapshots()
                .listen(
                  (orgSnap) {
                    latestOrgData = orgSnap.data();
                    if (latestUserData != null) {
                      controller.add(
                        _composeAccessProfile(latestUserData!, latestOrgData),
                      );
                    }
                  },
                  onError: controller.addError,
                );
          },
          onError: controller.addError,
          onDone: controller.close,
        );

    controller.onCancel = () {
      userSub.cancel();
      orgSub?.cancel();
    };

    return controller.stream;
  }

  static Map<String, String> _composeAccessProfile(
    Map<String, dynamic> userData,
    Map<String, dynamic>? orgData,
  ) {
    final mode = userData['businessMode']?.toString();
    final role = userData['role']?.toString();
    final orgId = userData['orgId']?.toString();
    final plan = orgData?['plan']?.toString() ?? userData['plan']?.toString();
    final planStatus =
        orgData?['planStatus']?.toString() ??
        userData['planStatus']?.toString();

    return {
      if (mode != null && mode.isNotEmpty) 'businessMode': mode,
      if (role != null && role.isNotEmpty) 'appRole': role,
      if (orgId != null && orgId.isNotEmpty) 'orgId': orgId,
      if (plan != null && plan.isNotEmpty) 'appPlan': plan,
      if (planStatus != null && planStatus.isNotEmpty) 'planStatus': planStatus,
    };
  }

  /// Syncs the studio's booking schedule to Firestore so that the
  /// [getBookingAvailability] Cloud Function can use real working hours.
  static Future<void> syncBookingSchedule(Map<String, dynamic> schedule) async {
    if (!_firebaseReady) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'bookingSchedule': schedule,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('[CloudProfileSync] syncBookingSchedule error: $e');
    }
  }
}
