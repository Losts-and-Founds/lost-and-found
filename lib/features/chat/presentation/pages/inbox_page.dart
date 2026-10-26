import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:lost_and_found/core/presentation/widgets/custom_circular_progress.dart';
import 'package:lost_and_found/core/presentation/widgets/error_page.dart';
import 'package:lost_and_found/features/chat/presentation/bloc/inbox/inbox_bloc.dart';
import 'package:lost_and_found/features/chat/presentation/pages/chat_page.dart';
import 'package:lost_and_found/utils/colors/custom_color.dart';
import 'package:lost_and_found/utils/theme/app_theme.dart';

class ChatThreadModel {
  final String roomId;
  final int itemId;
  final String contactName;
  final String initials;
  final String itemSubtitle;
  final String lastMessage;
  final String timestamp;
  final int unreadCount;
  final String? itemImageUrl;

  const ChatThreadModel({
    required this.roomId,
    required this.itemId,
    required this.contactName,
    required this.initials,
    required this.itemSubtitle,
    required this.lastMessage,
    required this.timestamp,
    required this.unreadCount,
    this.itemImageUrl,
  });
}

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  bool _isSearching = false;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatTimestamp(int? milliseconds) {
    if (milliseconds == null) return '';

    final timestamp = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    final now = DateTime.now();
    if (timestamp.year == now.year &&
        timestamp.month == now.month &&
        timestamp.day == now.day) {
      final hour = timestamp.hour % 12 == 0 ? 12 : timestamp.hour % 12;
      final minute = timestamp.minute.toString().padLeft(2, '0');
      final period = timestamp.hour < 12 ? 'AM' : 'PM';
      return '$hour:$minute $period';
    }

    return '${timestamp.month}/${timestamp.day}';
  }

  @override
  Widget build(BuildContext context) {
    final customColors =
        Theme.of(context).extension<CustomColors>() ?? lightCustomColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final mintColor = customColors.primaryAccent ?? const Color(0xFF52C46A);
    final secondaryTextColor =
        customColors.secondaryTextColor ?? const Color(0xFF8F99A8);
    final containerFill = customColors.cardFill ??
        (isDark ? const Color(0xFF131A2B) : const Color(0xFFFFFFFF));
    final borderColor = customColors.cardBorderColor ??
        (isDark ? const Color(0xFF1F2B45) : const Color(0xFFEDE8E1));
    final textPrimary = customColors.textPrimary ??
        (isDark ? Colors.white : const Color(0xFF1E232A));

    return BlocBuilder<InboxBloc, InboxState>(
      builder: (ctx, state) {
        if (state.isLoading) {
          return const Center(child: CustomCircularProgress(size: 60));
        }

        if (state.hasLoginOrLoadingError) {
          return ErrorPage(
            hasBottomBar: true,
            onRetry: () => ctx
                .read<InboxBloc>()
                .add(const InboxEvent.inboxContentCreated()),
          );
        }

        return StreamBuilder<List<Room>>(
          stream: state.userRooms,
          initialData: const [],
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                          'Could not load conversations. Please try again.'),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => ctx
                            .read<InboxBloc>()
                            .add(const InboxEvent.inboxContentCreated()),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final currentUid = auth.FirebaseAuth.instance.currentUser?.uid;
            final allThreads = <ChatThreadModel>[];
            final rooms = [...snapshot.data ?? const <Room>[]]..sort(
                (first, second) =>
                    (second.updatedAt ?? 0).compareTo(first.updatedAt ?? 0));
            for (final room in rooms) {
              final metadata = room.metadata ?? const <String, dynamic>{};
              if (metadata['active'] != true) continue;

              User? contact;
              for (final user in room.users) {
                if (user.id != currentUid) {
                  contact = user;
                  break;
                }
              }

              final metadataName = metadata['uid1'] == currentUid ||
                      metadata['id1'] == state.currentId
                  ? metadata['username2']
                  : metadata['username1'];
              final contactName = contact?.firstName ??
                  (metadataName is String && metadataName.isNotEmpty
                      ? metadataName
                      : 'Neighbour');
              final initials = contactName.length >= 2
                  ? contactName.substring(0, 2).toUpperCase()
                  : contactName.toUpperCase();
              final lastMsg = metadata['lastMessage'] as String? ?? '';
              final lastMessageId = metadata['lastMessageId'] as String?;
              final uidReadMessage = currentUid == null
                  ? null
                  : metadata['last-$currentUid'] as String?;
              final legacyReadMessage =
                  metadata['last-${state.currentId}'] as String?;
              final hasReadLastMessage = lastMessageId == null ||
                  uidReadMessage == lastMessageId ||
                  (uidReadMessage == null &&
                      legacyReadMessage == lastMessageId);
              final rawItemId = metadata['item'];
              final itemId = rawItemId is num
                  ? rawItemId.toInt()
                  : int.tryParse(rawItemId?.toString() ?? '') ?? 0;
              final itemTitle =
                  (metadata['title'] as String? ?? 'Item').toUpperCase();

              allThreads.add(
                ChatThreadModel(
                  roomId: room.id,
                  itemId: itemId,
                  contactName: contactName,
                  initials: initials,
                  itemSubtitle: itemTitle,
                  lastMessage: lastMsg,
                  timestamp: _formatTimestamp(room.updatedAt),
                  unreadCount: hasReadLastMessage ? 0 : 1,
                ),
              );
            }

            // Filter by search query if active
            final displayedThreads = allThreads.where((thread) {
              if (_searchQuery.isEmpty) return true;
              final q = _searchQuery.toLowerCase();
              return thread.contactName.toLowerCase().contains(q) ||
                  thread.itemSubtitle.toLowerCase().contains(q) ||
                  thread.lastMessage.toLowerCase().contains(q);
            }).toList();

            final totalUnreads = displayedThreads.fold<int>(
                0, (sum, t) => sum + (t.unreadCount > 0 ? 1 : 0));

            return Column(
              children: [
                // Header: Title "Messages" in serif, live "X UNREAD" badge, search icon on right
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Messages",
                            style: AppTypography.serifTitle(
                              context,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Live "X UNREAD" badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: mintColor.withOpacity(0.18),
                              borderRadius:
                                  BorderRadius.circular(AppRadius.badge),
                            ),
                            child: Text(
                              "$totalUnreads UNREAD",
                              style: AppTypography.uppercaseLabel(
                                context,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: mintColor,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Search icon button
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: containerFill,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor, width: 1),
                        ),
                        child: IconButton(
                          icon: Icon(
                            _isSearching
                                ? Icons.close_rounded
                                : Icons.search_rounded,
                            size: 20,
                            color: textPrimary,
                          ),
                          onPressed: () {
                            setState(() {
                              _isSearching = !_isSearching;
                              if (!_isSearching) {
                                _searchQuery = "";
                                _searchController.clear();
                              }
                            });
                          },
                          splashRadius: 20,
                        ),
                      ),
                    ],
                  ),
                ),

                // Expandable live search bar
                if (_isSearching)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 6.0),
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: containerFill,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor, width: 1),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        style: AppTypography.sansBody(context, fontSize: 14),
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val.trim();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Search messages or items...",
                          hintStyle: AppTypography.sansSecondary(context,
                              fontSize: 13),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          filled: false,
                          contentPadding: EdgeInsets.zero,
                          prefixIcon: Icon(Icons.search_rounded,
                              size: 18, color: secondaryTextColor),
                        ),
                      ),
                    ),
                  ),

                Expanded(
                  child: displayedThreads.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              allThreads.isEmpty
                                  ? 'No conversations yet. Start a chat from an item report.'
                                  : 'No conversations match your search.',
                              textAlign: TextAlign.center,
                              style: AppTypography.sansSecondary(context,
                                  fontSize: 14),
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 8.0),
                          itemCount: displayedThreads.length,
                          separatorBuilder: (_, __) => Divider(
                              color: borderColor.withOpacity(0.5), height: 1),
                          itemBuilder: (context, index) {
                            final thread = displayedThreads[index];
                            return _buildChatListItem(context, thread, isDark,
                                mintColor, secondaryTextColor, textPrimary);
                          },
                        ),
                ),

                // Bottom Safety Banner: Subtle card with safety notice
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: customColors.containerSoft ??
                          (isDark
                              ? const Color(0xFF131A2B)
                              : const Color(0xFFF3EFEA)),
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      border: Border.all(color: borderColor, width: 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: mintColor.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.shield_outlined,
                              size: 20, color: mintColor),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Meet in public places and verify details before handing items over.",
                            style: AppTypography.sansSecondary(
                              context,
                              fontSize: 12,
                              color: textPrimary.withOpacity(0.85),
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildChatListItem(
    BuildContext context,
    ChatThreadModel thread,
    bool isDark,
    Color mintColor,
    Color secondaryTextColor,
    Color textPrimary,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ChatScreen(
                itemId: thread.itemId,
                roomId: thread.roomId,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: Thumbnail of item + Avatar initials badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Item thumbnail
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF192238)
                          : const Color(0xFFF3EFEA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.work_outline_rounded,
                        size: 26,
                        color: mintColor.withOpacity(0.8),
                      ),
                    ),
                  ),
                  // Avatar initials badge
                  Positioned(
                    bottom: -3,
                    right: -5,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: mintColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 1.8,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          thread.initials,
                          style: TextStyle(
                            color:
                                isDark ? const Color(0xFF0B101D) : Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              // Center: Contact Name, Item Subtitle (uppercase grey text), and Last Message snippet preview
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      thread.contactName,
                      style: AppTypography.sansBold(context,
                          fontSize: 15, color: textPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      thread.itemSubtitle,
                      style: AppTypography.uppercaseLabel(
                        context,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: secondaryTextColor,
                        letterSpacing: 1.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      thread.lastMessage,
                      style: AppTypography.sansSecondary(
                        context,
                        fontSize: 13,
                        color: thread.unreadCount > 0
                            ? textPrimary
                            : secondaryTextColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // Right: Timestamp and unread count badge in Mint Green
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    thread.timestamp,
                    style: AppTypography.sansSecondary(
                      context,
                      fontSize: 11,
                      color: thread.unreadCount > 0
                          ? mintColor
                          : secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (thread.unreadCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: mintColor,
                        borderRadius: BorderRadius.circular(AppRadius.badge),
                      ),
                      child: Text(
                        "${thread.unreadCount}",
                        style: TextStyle(
                          color:
                              isDark ? const Color(0xFF0B101D) : Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    )
                  else
                    const SizedBox(height: 18),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
