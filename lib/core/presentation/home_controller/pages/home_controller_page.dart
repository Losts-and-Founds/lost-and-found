import 'package:badges/badges.dart' as badges;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lost_and_found/features/badges/presentation/bloc/badge_bloc.dart';
import 'package:lost_and_found/features/chat/presentation/bloc/inbox/inbox_bloc.dart';
import 'package:lost_and_found/features/chat/presentation/pages/inbox_page.dart';
import 'package:lost_and_found/features/item/presentation/bloc/search/search_bloc.dart';
import 'package:lost_and_found/features/item/presentation/pages/home_page.dart';
import 'package:lost_and_found/features/item/presentation/pages/search_page.dart';
import 'package:lost_and_found/features/user/presentation/bloc/user/user_bloc.dart';
import 'package:lost_and_found/features/user/presentation/pages/user_page.dart';
import 'package:lost_and_found/utils/colors/custom_color.dart';
import '../bloc/home_controller_bloc.dart';

class HomeControllerScreen extends StatelessWidget {
  final List<bool> hasPageBeenInitialized = [true, true, true, false, false];
  late final String? _userId = FirebaseAuth.instance.currentUser?.uid;
  late final Stream<QuerySnapshot<Map<String, dynamic>>>? _roomsStream =
      _userId == null
          ? null
          : FirebaseFirestore.instance
              .collection('rooms')
              .where('userIds', arrayContains: _userId)
              .snapshots();

  HomeControllerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Pages corresponding to tab indices:
    // 0: Home, 1: Search, 3: Inbox, 4: Profile
    final List<Widget> pages = [
      const HomeScreen(),
      const SearchScreen(),
      const SizedBox.shrink(), // Index 2 reserved for center button action
      const InboxScreen(),
      const UserScreen(),
    ];

    final customColors =
        Theme.of(context).extension<CustomColors>() ?? lightCustomColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final mintColor = customColors.primaryAccent ?? const Color(0xFF52C46A);
    final secondaryTextColor =
        customColors.secondaryTextColor ?? const Color(0xFF8F99A8);
    final navBg = customColors.cardFill ??
        (isDark ? const Color(0xFF131A2B) : const Color(0xFFFFFFFF));
    final borderColor = customColors.cardBorderColor ??
        (isDark ? const Color(0xFF1F2B45) : const Color(0xFFEDE8E1));

    return BlocBuilder<BadgeBloc, BadgeState>(
      builder: (badgeCtx, badgeState) =>
          BlocBuilder<HomeControllerBloc, HomeControllerState>(
        builder: (ctx, state) => BlocBuilder<SearchBloc, SearchState>(
          builder: (searchCtx, searchState) {
            // Ensure tabIndex is safe
            final currentTab =
                (state.tabIndex >= 0 && state.tabIndex < pages.length)
                    ? state.tabIndex
                    : 0;

            void selectTab(int index) {
              if (index < hasPageBeenInitialized.length &&
                  !hasPageBeenInitialized[index]) {
                if (index == 3) {
                  ctx
                      .read<InboxBloc>()
                      .add(const InboxEvent.inboxContentCreated());
                } else if (index == 4) {
                  ctx.read<UserBloc>().add(const UserEvent.contentCreated());
                }
                hasPageBeenInitialized[index] = true;
              }
              ctx
                  .read<HomeControllerBloc>()
                  .add(HomeControllerEvent.tabChanged(index));
            }

            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: SafeArea(
                bottom: false,
                child: IndexedStack(
                  index: currentTab == 2 ? 0 : currentTab,
                  children: pages,
                ),
              ),
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  color: navBg,
                  border: Border(
                    top: BorderSide(color: borderColor, width: 1.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                      blurRadius: 16,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.only(
                    top: 8, bottom: 16, left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Tab 1: Home
                    _buildNavItem(
                      context: context,
                      icon: Icons.home_rounded,
                      label: "Home",
                      isSelected: currentTab == 0,
                      onTap: () => selectTab(0),
                      badgeContent: badgeState.unreadReceivedClaims > 0 ||
                          badgeState.unreadNews > 0,
                      activeColor: mintColor,
                      inactiveColor: secondaryTextColor,
                    ),

                    // Tab 2: Search
                    _buildNavItem(
                      context: context,
                      icon: Icons.search_rounded,
                      label: "Search",
                      isSelected: currentTab == 1,
                      onTap: () => selectTab(1),
                      activeColor: mintColor,
                      inactiveColor: secondaryTextColor,
                    ),

                    // Floating Center "+" Action Button in Mint Green
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed("/insert"),
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: mintColor,
                          boxShadow: [
                            BoxShadow(
                              color: mintColor.withOpacity(0.4),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.add_rounded,
                            size: 32,
                            color:
                                isDark ? const Color(0xFF0B101D) : Colors.white,
                          ),
                        ),
                      ),
                    ),

                    // Tab 3: Inbox
                    _buildNavItem(
                      context: context,
                      icon: Icons.chat_bubble_outline_rounded,
                      label: "Inbox",
                      isSelected: currentTab == 3,
                      onTap: () => selectTab(3),
                      badgeContent: false,
                      activeColor: mintColor,
                      inactiveColor: secondaryTextColor,
                      badgeWidget: _roomsStream == null
                          ? null
                          : (context) => StreamBuilder<
                                  QuerySnapshot<Map<String, dynamic>>>(
                                stream: _roomsStream,
                                builder: (context, snapshot) {
                                  String? badgeText;
                                  if (snapshot.hasError) {
                                    badgeText = '!';
                                  } else if (snapshot.hasData &&
                                      _userId != null) {
                                    var unreadCount = 0;
                                    for (final room in snapshot.data!.docs) {
                                      final metadata = room.data()['metadata']
                                              as Map<String, dynamic>? ??
                                          const {};
                                      final storedCount =
                                          metadata['unread-$_userId'];
                                      if (storedCount is num) {
                                        unreadCount += storedCount.toInt();
                                      } else {
                                        final lastMessageId =
                                            metadata['lastMessageId'];
                                        if (lastMessageId is String &&
                                            lastMessageId.isNotEmpty &&
                                            metadata['last-$_userId'] !=
                                                lastMessageId) {
                                          unreadCount++;
                                        }
                                      }
                                    }
                                    if (unreadCount > 0) {
                                      badgeText = unreadCount > 99
                                          ? '99+'
                                          : '$unreadCount';
                                    }
                                  }
                                  return badges.Badge(
                                    showBadge: badgeText != null,
                                    badgeContent: badgeText == null
                                        ? null
                                        : Text(
                                            badgeText,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                          ),
                                    position: badges.BadgePosition.topEnd(
                                        top: -8, end: -9),
                                    badgeStyle: badges.BadgeStyle(
                                      badgeColor: mintColor,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 3),
                                    ),
                                    child: Icon(
                                      Icons.chat_bubble_outline_rounded,
                                      size: 24,
                                      color: currentTab == 3
                                          ? mintColor
                                          : secondaryTextColor,
                                    ),
                                  );
                                },
                              ),
                    ),

                    // Tab 4: Profile
                    _buildNavItem(
                      context: context,
                      icon: Icons.person_outline_rounded,
                      label: "Profile",
                      isSelected: currentTab == 4,
                      onTap: () => selectTab(4),
                      activeColor: mintColor,
                      inactiveColor: secondaryTextColor,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required Color activeColor,
    required Color inactiveColor,
    bool badgeContent = false,
    WidgetBuilder? badgeWidget,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            badgeWidget?.call(context) ??
                badges.Badge(
                  showBadge: badgeContent,
                  position: badges.BadgePosition.topEnd(top: -3, end: -4),
                  badgeStyle: badges.BadgeStyle(
                    badgeColor: activeColor,
                    padding: const EdgeInsets.all(4),
                  ),
                  child: Icon(
                    icon,
                    size: 24,
                    color: isSelected ? activeColor : inactiveColor,
                  ),
                ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? activeColor : inactiveColor,
              ),
            ),
            const SizedBox(height: 2),
            // Active indicator dot
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 3,
              width: isSelected ? 16 : 0,
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
