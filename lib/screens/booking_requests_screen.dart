import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/access_guard.dart';
import '../core/constants.dart';
import '../core/subscription_texts.dart';

enum _Filter { pending, all, accepted, declined }

class BookingRequestsScreen extends StatefulWidget {
  const BookingRequestsScreen({super.key});

  @override
  State<BookingRequestsScreen> createState() => _BookingRequestsScreenState();
}

class _BookingRequestsScreenState extends State<BookingRequestsScreen> {
  _Filter _filter = _Filter.pending;
  final Set<String> _pendingRequestIds = <String>{};

  static const Set<String> _allowedStatuses = {
    'pending',
    'accepted',
    'declined',
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (!AccessGuard.canUseOnlineBooking()) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.bookingRequestsTitle)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      SubscriptionTexts.bookingProTitle(context),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(SubscriptionTexts.bookingProMessage(context)),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => AccessGuard.showUpgradePrompt(
                          context,
                          title: SubscriptionTexts.bookingProTitle(context),
                          message: SubscriptionTexts.bookingProMessage(context),
                          requiredPlan: AppPlan.pro,
                        ),
                        child: Text(SubscriptionTexts.viewPlans(context)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (Firebase.apps.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.bookingRequestsTitle)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(l10n.bookingRequestsFirebaseUnavailable),
          ),
        ),
      );
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.bookingRequestsTitle)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(l10n.bookingRequestsSignInRequired),
          ),
        ),
      );
    }

    final stream = FirebaseFirestore.instance
        .collection('booking_requests')
        .where('masterUid', isEqualTo: user.uid)
        .limit(50)
        .snapshots();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.bookingRequestsTitle)),
      body: Column(
        children: [
          _FilterBar(
            selected: _filter,
            onChanged: (f) => setState(() => _filter = f),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _SkeletonList();
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        l10n.bookingRequestsError(snapshot.error.toString()),
                      ),
                    ),
                  );
                }

                final allDocs = (snapshot.data?.docs ?? const [])
                  ..sort((a, b) {
                    final aMs = _firestoreTimeToMs(a.data()['createdAt']);
                    final bMs = _firestoreTimeToMs(b.data()['createdAt']);
                    return bMs.compareTo(aMs);
                  });
                final docs = allDocs.where((doc) {
                  final status = (doc.data()['status']?.toString() ?? 'pending')
                      .toLowerCase();
                  switch (_filter) {
                    case _Filter.pending:
                      return status == 'pending';
                    case _Filter.accepted:
                      return status == 'accepted';
                    case _Filter.declined:
                      return status == 'declined';
                    case _Filter.all:
                      return true;
                  }
                }).toList();

                if (docs.isEmpty) {
                  return _EmptyState(
                    filter: _filter,
                    hasPendingInAll: allDocs.any(
                      (d) =>
                          (d.data()['status']?.toString() ?? '') == 'pending',
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
                  itemCount: docs.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data();
                    final status = (data['status']?.toString() ?? 'pending')
                        .toLowerCase();
                    final isLoading = _pendingRequestIds.contains(doc.id);

                    return _RequestCard(
                      docId: doc.id,
                      data: data,
                      status: status,
                      isLoading: isLoading,
                      onAccept: status == 'pending'
                          ? () => _handleSetStatus(
                              requestId: doc.id,
                              status: 'accepted',
                            )
                          : null,
                      onDecline: status == 'pending'
                          ? () => _handleDecline(doc.id)
                          : null,
                      onCall: () =>
                          _call(data['clientPhone']?.toString() ?? ''),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleDecline(String requestId) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.bookingRequestDecline),
        content: Text(l10n.bookingRequestsDeclineConfirmContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: Text(l10n.bookingRequestDecline),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _handleSetStatus(requestId: requestId, status: 'declined');
  }

  Future<void> _handleSetStatus({
    required String requestId,
    required String status,
  }) async {
    if (_pendingRequestIds.contains(requestId)) return;

    setState(() => _pendingRequestIds.add(requestId));

    try {
      _validateStatus(status);
      await FirebaseFirestore.instance
          .collection('booking_requests')
          .doc(requestId)
          .update({
            'status': status,
            'updatedAt': FieldValue.serverTimestamp(),
          });

      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;
      final message = status == 'accepted'
          ? l10n.bookingRequestsAcceptedFeedback
          : l10n.bookingRequestsDeclinedFeedback;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.errorMessage(error.toString())),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      _pendingRequestIds.remove(requestId);
      if (mounted) setState(() {});
    }
  }

  Future<void> _call(String phone) async {
    try {
      final sanitized = _sanitizePhone(phone);
      if (sanitized.isEmpty) {
        if (!mounted) return;
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.enterValidPhone),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
      final uri = Uri(scheme: 'tel', path: sanitized);
      if (!await canLaunchUrl(uri)) {
        if (!mounted) return;
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorMessage('Unable to start phone call')),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
      await launchUrl(uri);
    } catch (error) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.errorMessage(error.toString())),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _validateStatus(String status) {
    if (!_allowedStatuses.contains(status)) {
      throw ArgumentError.value(
        status,
        'status',
        'Unsupported booking request status',
      );
    }
  }

  String _sanitizePhone(String phone) {
    final trimmed = phone.trim();
    if (trimmed.isEmpty) return '';
    final hasLeadingPlus = trimmed.startsWith('+');
    final digits = trimmed.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return '';
    return hasLeadingPlus ? '+$digits' : digits;
  }
}

int _firestoreTimeToMs(dynamic value) {
  if (value is Timestamp) {
    return value.millisecondsSinceEpoch;
  }
  if (value is num) {
    return value.toInt();
  }
  return 0;
}

// -- Filter bar ---------------------------------------------------------------

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.selected, required this.onChanged});

  final _Filter selected;
  final ValueChanged<_Filter> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final filters = [
      (_Filter.pending, l10n.bookingRequestStatusPending),
      (_Filter.all, l10n.bookingRequestsFilterAll),
      (_Filter.accepted, l10n.bookingRequestStatusAccepted),
      (_Filter.declined, l10n.bookingRequestStatusDeclined),
    ];

    return Container(
      color: colorScheme.surface,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((entry) {
            final (filter, label) = entry;
            final isSelected = selected == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(label),
                selected: isSelected,
                onSelected: (_) => onChanged(filter),
                showCheckmark: false,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// -- Empty state --------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.filter, required this.hasPendingInAll});

  final _Filter filter;
  final bool hasPendingInAll;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final String message;
    final IconData icon;

    if (filter == _Filter.pending) {
      message = l10n.bookingRequestsEmptyNew;
      icon = Icons.check_circle_outline;
    } else {
      message = l10n.bookingRequestsEmpty;
      icon = Icons.inbox_outlined;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -- Skeleton loader ----------------------------------------------------------

class _SkeletonList extends StatefulWidget {
  @override
  State<_SkeletonList> createState() => _SkeletonListState();
}

class _SkeletonListState extends State<_SkeletonList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.4,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
          itemCount: 4,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) =>
              _SkeletonCard(opacity: _animation.value),
        );
      },
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({required this.opacity});

  final double opacity;

  @override
  Widget build(BuildContext context) {
    final baseColor = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: opacity * 0.12);

    Widget block({double width = double.infinity, double height = 14}) =>
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(6),
          ),
        );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: block(height: 16)),
                const SizedBox(width: 12),
                block(width: 72, height: 26),
              ],
            ),
            const SizedBox(height: 10),
            block(width: 220),
            const SizedBox(height: 6),
            block(width: 160),
            const SizedBox(height: 6),
            block(width: 120),
            const SizedBox(height: 14),
            Row(
              children: [
                block(width: 88, height: 32),
                const SizedBox(width: 8),
                block(width: 88, height: 32),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// -- Request card -------------------------------------------------------------

class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.docId,
    required this.data,
    required this.status,
    required this.isLoading,
    required this.onAccept,
    required this.onDecline,
    required this.onCall,
  });

  final String docId;
  final Map<String, dynamic> data;
  final String status;
  final bool isLoading;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  final VoidCallback onCall;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final clientName = data['clientName']?.toString() ?? '-';
    final phone = data['clientPhone']?.toString() ?? '';
    final service = data['service']?.toString() ?? '-';
    final car = data['car']?.toString() ?? '';
    final date = data['preferredDate']?.toString() ?? '-';
    final time = data['preferredTime']?.toString() ?? '-';
    final note = data['note']?.toString().trim() ?? '';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: name + status chip
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    clientName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _StatusChip(status: status),
              ],
            ),
            const SizedBox(height: 8),
            // Service
            Row(
              children: [
                const Icon(Icons.build_outlined, size: 15),
                const SizedBox(width: 6),
                Expanded(
                  child: Text('${l10n.bookingRequestServiceLabel}: $service'),
                ),
              ],
            ),
            if (car.isNotEmpty) ...[
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.directions_car_outlined, size: 15),
                  const SizedBox(width: 6),
                  Text('${l10n.bookingRequestCarLabel}: $car'),
                ],
              ),
            ],
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.schedule_outlined, size: 15),
                const SizedBox(width: 6),
                Text('${l10n.bookingRequestScheduleLabel}: $date $time'),
              ],
            ),
            if (phone.isNotEmpty) ...[
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.phone_outlined, size: 15),
                  const SizedBox(width: 6),
                  Text('${l10n.bookingRequestPhoneLabel}: $phone'),
                ],
              ),
            ],
            if (note.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.notes_outlined, size: 15),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${l10n.bookingRequestNoteLabel}: $note',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            // Actions
            if (isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: LinearProgressIndicator(),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (onAccept != null)
                    FilledButton.icon(
                      onPressed: onAccept,
                      icon: const Icon(Icons.check, size: 18),
                      label: Text(l10n.bookingRequestAccept),
                    ),
                  if (onDecline != null)
                    OutlinedButton.icon(
                      onPressed: onDecline,
                      icon: const Icon(Icons.close, size: 18),
                      label: Text(l10n.bookingRequestDecline),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                        side: BorderSide(
                          color: Theme.of(
                            context,
                          ).colorScheme.error.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  if (phone.isNotEmpty)
                    TextButton.icon(
                      onPressed: onCall,
                      icon: const Icon(Icons.call_outlined, size: 18),
                      label: Text(l10n.bookingRequestCall),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

// -- Status chip --------------------------------------------------------------

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final Color color;
    final String label;

    switch (status) {
      case 'accepted':
        color = Colors.green;
        label = l10n.bookingRequestStatusAccepted;
        break;
      case 'declined':
        color = Colors.redAccent;
        label = l10n.bookingRequestStatusDeclined;
        break;
      default:
        color = Colors.orange;
        label = l10n.bookingRequestStatusPending;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
