import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../chat/chat_models.dart';
import '../chat/firestore_chat_service.dart';
import '../core/constants.dart';
import 'chat_room_screen.dart';

class ChatListScreen extends StatefulWidget {
  final bool isTeamMode;

  const ChatListScreen({super.key, this.isTeamMode = true});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  bool _useInternalScope = true;
  late final TextEditingController _myIdController;
  late final TextEditingController _myNameController;

  bool get _isInternalScope => widget.isTeamMode && _useInternalScope;

  @override
  void initState() {
    super.initState();
    final settings = Hive.box(HiveBoxes.settings);
    final firebaseUser = Firebase.apps.isNotEmpty
        ? FirebaseAuth.instance.currentUser
        : null;
    final fallbackUserId = firebaseUser?.uid ?? '';
    final fallbackUserName =
        firebaseUser?.displayName ?? firebaseUser?.email ?? '';

    _myIdController = TextEditingController(
      text: settings.get('chatUserId')?.toString() ?? fallbackUserId,
    );
    _myNameController = TextEditingController(
      text: settings.get('chatUserName')?.toString() ?? fallbackUserName,
    );
  }

  @override
  void dispose() {
    _myIdController.dispose();
    _myNameController.dispose();
    super.dispose();
  }

  FirestoreChatService? _getChatService() {
    if (!Firebase.apps.isNotEmpty) {
      return null;
    }

    final settings = Hive.box(HiveBoxes.settings);
    final orgId = settings.get('orgId')?.toString();
    return FirestoreChatService(
      orgId: _isInternalScope ? orgId : null,
      isTeamScoped: _isInternalScope,
    );
  }

  String _resolvedCurrentUserId() {
    final settings = Hive.box(HiveBoxes.settings);
    final firebaseUser = Firebase.apps.isNotEmpty
        ? FirebaseAuth.instance.currentUser
        : null;
    final firebaseUid = firebaseUser?.uid ?? '';
    if (firebaseUid.isNotEmpty) {
      return firebaseUid;
    }
    if (_isInternalScope) {
      return '';
    }
    return _myIdController.text.trim().isNotEmpty
        ? _myIdController.text.trim()
        : (firebaseUser?.uid ?? settings.get('chatUserId')?.toString() ?? '');
  }

  String _resolvedCurrentUserName() {
    final settings = Hive.box(HiveBoxes.settings);
    final firebaseUser = Firebase.apps.isNotEmpty
        ? FirebaseAuth.instance.currentUser
        : null;
    if (_isInternalScope) {
      return settings.get('authUserLabel')?.toString() ??
          firebaseUser?.displayName ??
          firebaseUser?.email ??
          firebaseUser?.uid ??
          '';
    }
    return _myNameController.text.trim().isNotEmpty
        ? _myNameController.text.trim()
        : (firebaseUser?.displayName ??
              firebaseUser?.email ??
              settings.get('chatUserName')?.toString() ??
              '');
  }

  Future<void> _saveMe() async {
    final l10n = AppLocalizations.of(context)!;
    final settings = Hive.box(HiveBoxes.settings);
    await settings.put('chatUserId', _myIdController.text.trim());
    await settings.put('chatUserName', _myNameController.text.trim());
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.chatProfileSaved)));
    setState(() {});
  }

  Future<void> _openCreateChatDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final settings = Hive.box(HiveBoxes.settings);
    final currentOrgId = settings.get('orgId')?.toString();
    final chatService = _getChatService();
    if (chatService == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.chatUnavailableShort)));
      return;
    }

    final peerIdController = TextEditingController();
    final peerNameController = TextEditingController();
    final searchController = TextEditingController();

    Future<void> findPeer() async {
      final query = searchController.text.trim();
      if (query.isEmpty) {
        return;
      }

      final lower = query.toLowerCase();
      final users = FirebaseFirestore.instance.collection('public_users');
      Query<Map<String, dynamic>> scopedQuery = users;

      if (_isInternalScope) {
        if (currentOrgId == null || currentOrgId.isEmpty) {
          if (!mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.chatUnavailableShort)));
          return;
        }
        scopedQuery = scopedQuery.where('orgId', isEqualTo: currentOrgId);
      }

      QuerySnapshot<Map<String, dynamic>> snapshot;
      final byUid = await scopedQuery
          .where('uid', isEqualTo: query)
          .limit(10)
          .get();

      if (byUid.docs.isNotEmpty) {
        snapshot = byUid;
      } else {
        snapshot = await scopedQuery
            .orderBy('searchName')
            .startAt([lower])
            .endAt(['$lower\uf8ff'])
            .limit(10)
            .get();
      }

      if (snapshot.docs.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.clientsNotFound)));
        return;
      }

      if (!mounted) return;

      final selected = await showModalBottomSheet<Map<String, dynamic>>(
        context: context,
        builder: (sheetContext) => SafeArea(
          child: ListView.builder(
            itemCount: snapshot.docs.length,
            itemBuilder: (context, index) {
              final data = snapshot.docs[index].data();
              final uid = data['uid']?.toString() ?? snapshot.docs[index].id;
              final name = data['displayName']?.toString() ?? uid;
              return ListTile(
                title: Text(name),
                subtitle: Text(uid),
                onTap: () {
                  Navigator.pop(sheetContext, {'uid': uid, 'name': name});
                },
              );
            },
          ),
        ),
      );

      if (selected == null) {
        return;
      }

      peerIdController.text = selected['uid']?.toString() ?? '';
      peerNameController.text = selected['name']?.toString() ?? '';
    }

    final roomId = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          _isInternalScope
              ? l10n.chatCreateDialogTitle
              : l10n.chatCreateExternalTitle,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: l10n.searchClientsHint,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: findPeer,
                ),
              ),
              onSubmitted: (_) => findPeer(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: peerIdController,
              decoration: InputDecoration(
                labelText: _isInternalScope
                    ? l10n.chatPeerIdLabelTeam
                    : l10n.chatPeerIdLabelExternal,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: peerNameController,
              decoration: InputDecoration(
                labelText: _isInternalScope
                    ? l10n.chatPeerNameLabelTeam
                    : l10n.chatPeerNameLabelExternal,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final myId = _resolvedCurrentUserId();
              final myName = _resolvedCurrentUserName();
              final peerId = peerIdController.text.trim();
              final peerName = peerNameController.text.trim();

              if (myId.isEmpty ||
                  myName.isEmpty ||
                  peerId.isEmpty ||
                  peerName.isEmpty) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(content: Text(l10n.chatProfileFillSubtitleTeam)),
                );
                return;
              }

              try {
                final createdRoomId = await chatService.createOrGetDirectRoom(
                  currentUserId: myId,
                  currentUserName: myName,
                  peerUserId: peerId,
                  peerUserName: peerName,
                );

                if (!ctx.mounted) return;
                Navigator.pop(ctx, createdRoomId);
              } catch (_) {
                if (!ctx.mounted) return;
                ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(content: Text(l10n.chatConnectionError)),
                );
              }
            },
            child: Text(l10n.chatCreateAction),
          ),
        ],
      ),
    );

    peerIdController.dispose();
    peerNameController.dispose();
    searchController.dispose();

    if (!mounted || roomId == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatRoomScreen(
          roomId: roomId,
          currentUserId: _resolvedCurrentUserId(),
          currentUserName: _resolvedCurrentUserName(),
          roomTitle: l10n.chatDialogTitle,
          isTeamMode: _isInternalScope,
          orgId: _isInternalScope
              ? Hive.box(HiveBoxes.settings).get('orgId')?.toString()
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = Hive.box(HiveBoxes.settings);
    final orgId = settings.get('orgId')?.toString();
    final chatService = _getChatService();
    final userId = _resolvedCurrentUserId();
    final userName = _resolvedCurrentUserName();
    final title = _isInternalScope
        ? l10n.chatScreenTitleTeam
        : l10n.chatScreenTitleExternal;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: chatService == null ? null : _openCreateChatDialog,
        icon: const Icon(Icons.add_comment_outlined),
        label: Text(l10n.chatNewChatButton),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (widget.isTeamMode) ...[
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: Text(l10n.chatScreenTitleTeam),
                        selected: _useInternalScope,
                        onSelected: (_) {
                          setState(() => _useInternalScope = true);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ChoiceChip(
                        label: Text(l10n.chatScreenTitleExternal),
                        selected: !_useInternalScope,
                        onSelected: (_) {
                          setState(() => _useInternalScope = false);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (!_isInternalScope)
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextField(
                      controller: _myIdController,
                      decoration: InputDecoration(
                        labelText: l10n.chatMyIdLabel,
                        hintText: l10n.chatMyIdHint,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _myNameController,
                      decoration: InputDecoration(
                        labelText: l10n.chatMyNameLabel,
                        hintText: l10n.chatMyNameHint,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: _saveMe,
                        icon: const Icon(Icons.save_outlined),
                        label: Text(l10n.save),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          if (_isInternalScope &&
              (chatService == null || orgId == null || orgId.isEmpty))
            _InfoCard(
              title: l10n.chatUnavailableTitle,
              subtitle: l10n.chatUnavailableSubtitle,
            )
          else if (_isInternalScope && (userId.isEmpty || userName.isEmpty))
            _InfoCard(
              title: l10n.chatUnavailableTitle,
              subtitle: l10n.chatUnavailableShort,
            )
          else if (_isInternalScope)
            Card(
              child: ListTile(
                leading: const Icon(Icons.forum_outlined),
                title: Text(l10n.chatScreenTitleTeam),
                subtitle: Text(l10n.chatDialogTitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatRoomScreen(
                        roomId: 'general',
                        currentUserId: userId,
                        currentUserName: userName,
                        roomTitle: l10n.chatScreenTitleTeam,
                        isTeamMode: true,
                        orgId: orgId,
                      ),
                    ),
                  );
                },
              ),
            )
          else if (chatService == null)
            _InfoCard(
              title: l10n.chatUnavailableTitle,
              subtitle: l10n.chatUnavailableSubtitle,
            )
          else if (userId.isEmpty)
            _InfoCard(
              title: _isInternalScope
                  ? l10n.chatProfileFillTitleTeam
                  : l10n.chatProfileFillTitleExternal,
              subtitle: _isInternalScope
                  ? l10n.chatProfileFillSubtitleTeam
                  : l10n.chatProfileFillSubtitleExternal,
            )
          else
            _RoomList(
              chatService: chatService,
              currentUserId: userId,
              currentUserName: userName,
              isTeamMode: _isInternalScope,
              orgId: _isInternalScope ? orgId : null,
            ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _RoomList extends StatelessWidget {
  const _RoomList({
    required this.chatService,
    required this.currentUserId,
    required this.currentUserName,
    required this.isTeamMode,
    this.orgId,
  });

  final FirestoreChatService chatService;
  final String currentUserId;
  final String currentUserName;
  final bool isTeamMode;
  final String? orgId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return StreamBuilder<List<ChatRoomPreview>>(
      stream: chatService.watchRoomsForUser(currentUserId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _InfoCard(
            title: l10n.chatErrorTitle,
            subtitle: l10n.chatErrorSubtitle,
          );
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final rooms = snapshot.data!;
        if (rooms.isEmpty) {
          return _InfoCard(
            title: l10n.chatEmptyTitle,
            subtitle: l10n.chatEmptySubtitle,
          );
        }

        return Column(
          children: rooms.map((room) {
            final title = room.participantNames
                .where((name) => name.isNotEmpty)
                .join(' • ');

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(
                  title.isEmpty ? '${l10n.chatDialogTitle} ${room.id}' : title,
                ),
                subtitle: Text(
                  room.lastMessage.isEmpty
                      ? l10n.chatNoMessages
                      : room.lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatRoomScreen(
                        roomId: room.id,
                        currentUserId: currentUserId,
                        currentUserName: currentUserName,
                        roomTitle: title.isEmpty ? l10n.chatDialogTitle : title,
                        isTeamMode: isTeamMode,
                        orgId: orgId,
                      ),
                    ),
                  );
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(subtitle, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
