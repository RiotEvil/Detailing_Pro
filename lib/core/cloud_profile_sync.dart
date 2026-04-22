import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'constants.dart';

class CloudProfileSync {
  CloudProfileSync._();

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
    final normalizedEmail = (user.email ?? '').trim().toLowerCase();
    await FirebaseFirestore.instance
        .collection('public_users')
        .doc(user.uid)
        .set({
          'uid': user.uid,
          'displayName':
              user.displayName ?? fallbackName ?? user.email ?? 'user',
          'email': user.email,
          'searchName': normalizedName,
          'searchEmail': normalizedEmail,
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

    final firestore = FirebaseFirestore.instance;
    final orgId = 'org_${user.uid}';

    final organizations = firestore.collection('organizations');
    final users = firestore.collection('users');

    await organizations.doc(orgId).set({
      'orgId': orgId,
      'ownerId': user.uid,
      'businessMode': mode.name,
      'updatedAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    final role = mode == BusinessMode.team
        ? AppRole.director.name
        : AppRole.masterOwner.name;

    await users.doc(user.uid).set({
      'orgId': orgId,
      'businessMode': mode.name,
      'role': role,
      'updatedAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await firestore.collection('public_users').doc(user.uid).set({
      'orgId': orgId,
      'businessMode': mode.name,
      'role': role,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await ensurePlanDefaults(orgId: orgId);
  }

  static Future<void> syncRole(AppRole role) async {
    if (!_firebaseReady) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    final users = FirebaseFirestore.instance.collection('users');
    await users.doc(user.uid).set({
      'role': role.name,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .collection('public_users')
        .doc(user.uid)
        .set({
          'role': role.name,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
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

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final data = snapshot.data();
    if (data == null) {
      return null;
    }

    final mode = data['businessMode']?.toString();
    final role = data['role']?.toString();
    final orgId = data['orgId']?.toString();
    final plan = data['plan']?.toString();
    final planStatus = data['planStatus']?.toString();

    return {
      if (mode != null && mode.isNotEmpty) 'businessMode': mode,
      if (role != null && role.isNotEmpty) 'appRole': role,
      if (orgId != null && orgId.isNotEmpty) 'orgId': orgId,
      if (plan != null && plan.isNotEmpty) 'appPlan': plan,
      if (planStatus != null && planStatus.isNotEmpty) 'planStatus': planStatus,
    };
  }

  static Stream<Map<String, String>> watchAccessProfile() {
    if (!_firebaseReady) {
      return const Stream<Map<String, String>>.empty();
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Stream<Map<String, String>>.empty();
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((snapshot) {
          final data = snapshot.data();
          if (data == null) {
            return <String, String>{};
          }

          final mode = data['businessMode']?.toString();
          final role = data['role']?.toString();
          final orgId = data['orgId']?.toString();
          final plan = data['plan']?.toString();
          final planStatus = data['planStatus']?.toString();

          return {
            if (mode != null && mode.isNotEmpty) 'businessMode': mode,
            if (role != null && role.isNotEmpty) 'appRole': role,
            if (orgId != null && orgId.isNotEmpty) 'orgId': orgId,
            if (plan != null && plan.isNotEmpty) 'appPlan': plan,
            if (planStatus != null && planStatus.isNotEmpty)
              'planStatus': planStatus,
          };
        });
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
