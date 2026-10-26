import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_and_found/core/presentation/app_global/bloc/app_global_bloc.dart';
import 'package:lost_and_found/core/presentation/home_controller/bloc/home_controller_bloc.dart';
import 'package:lost_and_found/core/presentation/widgets/error_page.dart';
import 'package:lost_and_found/features/badges/presentation/bloc/badge_bloc.dart';
import 'package:lost_and_found/features/chat/presentation/bloc/inbox/inbox_bloc.dart';
import 'package:lost_and_found/features/item/presentation/bloc/home/home_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as chat_types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:lost_and_found/features/item/presentation/bloc/search/search_bloc.dart';
import 'package:lost_and_found/features/user/presentation/bloc/user/user_bloc.dart';
import 'package:lost_and_found/utils/colors/custom_color.dart';
import 'package:lost_and_found/utils/theme/app_theme.dart';
import 'package:lost_and_found/utils/utility.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  Future<void> _pickAvatarImage(BuildContext ctx) async {
    final picker = ImagePicker();
    try {
      final img = await picker.pickImage(source: ImageSource.gallery);
      if (img != null) {
        ctx.read<UserBloc>().add(UserEvent.imageChanged(img.path));
      }
    } catch (_) {}
  }

  void _showLanguageSheet(BuildContext ctx, Locale currentLocale) {
    final customColors =
        Theme.of(ctx).extension<CustomColors>() ?? lightCustomColors;
    final mintColor = customColors.primaryAccent ?? const Color(0xFF52C46A);

    showModalBottomSheet(
      context: ctx,
      backgroundColor:
          customColors.cardFill ?? Theme.of(ctx).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.modalTop)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                "Select Language",
                style: AppTypography.serifHeading(ctx, fontSize: 20),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text("English",
                    style: AppTypography.sansBold(ctx, fontSize: 15)),
                trailing: currentLocale.languageCode == "en"
                    ? Icon(Icons.check_rounded, color: mintColor)
                    : null,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onTap: () {
                  ctx
                      .read<AppGlobalBloc>()
                      .add(const AppGlobalEvent.localeChanged(Locale("en")));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text("Italiano",
                    style: AppTypography.sansBold(ctx, fontSize: 15)),
                trailing: currentLocale.languageCode == "it"
                    ? Icon(Icons.check_rounded, color: mintColor)
                    : null,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onTap: () {
                  ctx
                      .read<AppGlobalBloc>()
                      .add(const AppGlobalEvent.localeChanged(Locale("it")));
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, BuildContext userContext) {
    final customColors =
        Theme.of(context).extension<CustomColors>() ?? lightCustomColors;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor:
            customColors.cardFill ?? Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.card)),
        title: Text("Log Out",
            style: AppTypography.serifHeading(context, fontSize: 20)),
        content: Text(
          "Are you sure you want to log out from Lost&Found?",
          style: AppTypography.sansBody(context, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text("Cancel", style: AppTypography.sansBody(context)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              userContext.read<UserBloc>().add(const UserEvent.logout());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFA61C32),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Log Out"),
          ),
        ],
      ),
    );
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

    return BlocConsumer<AppGlobalBloc, AppGlobalState>(
      listener: (appGlobalCtx, appGlobalState) {},
      builder: (appGlobalCtx, appGlobalState) =>
          BlocConsumer<UserBloc, UserState>(
        listener: (ctx, state) {
          final logoutFailureOrSuccess = state.logoutFailureOrSuccess;
          if (logoutFailureOrSuccess != null) {
            logoutFailureOrSuccess.fold(
              (failure) => showBasicErrorSnackbar(context, failure),
              (_) {
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacementNamed(context, "/tutorial");

                ctx.read<HomeBloc>().add(const HomeEvent.restoreInitial());
                ctx.read<SearchBloc>().add(const SearchEvent.restoreInitial());
                ctx
                    .read<HomeControllerBloc>()
                    .add(const HomeControllerEvent.restoreInitial());
                ctx.read<BadgeBloc>().add(const BadgeEvent.restoreInitial());
                ctx.read<InboxBloc>().add(const InboxEvent.restoreInitial());
                ctx.read<UserBloc>().add(const UserEvent.restoreInitial());

                showBasicSuccessSnackbar(context, "Logged out successfully.");
              },
            );
          }

          final imageFailureOrSuccess = state.imageUploadFailureOrSuccess;
          if (imageFailureOrSuccess != null) {
            imageFailureOrSuccess.fold(
              (failure) => showBasicErrorSnackbar(context, failure),
              (_) => showBasicSuccessSnackbar(
                  context, "Avatar updated successfully!"),
            );
          }
        },
        builder: (ctx, state) {
          if (state.hasLoadingError) {
            return ErrorPage(
                onRetry: () =>
                    ctx.read<UserBloc>().add(const UserEvent.contentCreated()));
          }

          final authUser = FirebaseAuth.instance.currentUser;
          final email = state.userEmail ?? authUser?.email ?? '';
          final username = state.user?.username ??
              authUser?.displayName ??
              (email.contains('@') ? email.split('@').first : 'User');
          final isEmailVerified = authUser?.emailVerified == true;

          // Determine current dark theme state
          final bool isDarkThemeActive = appGlobalState.theme ==
                  ThemeMode.dark ||
              (appGlobalState.theme == ThemeMode.system &&
                  MediaQuery.of(context).platformBrightness == Brightness.dark);

          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: authUser == null
                ? null
                : FirebaseFirestore.instance
                    .collection('items')
                    .where('ownerId', isEqualTo: authUser.uid)
                    .snapshots(),
            builder: (context, itemSnapshot) {
              if (itemSnapshot.hasError) {
                return const Center(
                    child: Text('Could not load profile activity.'));
              }
              final items = itemSnapshot.data?.docs ?? const [];
              final postsCount = items.length;
              final returnedCount = items.where((doc) {
                final status = doc.data()['status'];
                return status == 'resolved';
              }).length;

              return StreamBuilder<List<chat_types.Room>>(
                stream:
                    authUser == null ? null : FirebaseChatCore.instance.rooms(),
                builder: (context, roomSnapshot) {
                  if (roomSnapshot.hasError) {
                    return const Center(
                        child: Text('Could not load profile activity.'));
                  }
                  final chatsCount =
                      (roomSnapshot.data ?? const <chat_types.Room>[])
                          .where((room) => room.metadata?['active'] == true)
                          .length;

                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 16.0),
                    children: [
                      // Screen Title: "Profile" in serif font
                      Text(
                        "Profile",
                        style: AppTypography.serifTitle(
                          context,
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 1. Profile Card: Avatar with camera edit badge, username, email, Verified member badge
                      Container(
                        decoration: BoxDecoration(
                          color: containerFill,
                          borderRadius: BorderRadius.circular(AppRadius.card),
                          border: Border.all(color: borderColor, width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(isDark ? 0.25 : 0.04),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Avatar image with camera edit badge
                            Stack(
                              children: [
                                Container(
                                  width: 76,
                                  height: 76,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: mintColor.withOpacity(0.15),
                                    border:
                                        Border.all(color: mintColor, width: 2),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: state.imagePath != null &&
                                          File(state.imagePath!).existsSync()
                                      ? Image.file(File(state.imagePath!),
                                          fit: BoxFit.cover)
                                      : (state.user?.id != null
                                          ? Image.network(
                                              state.imagePath ?? '',
                                              fit: BoxFit.cover,
                                              headers: {
                                                "Authorization":
                                                    "Bearer ${state.token}"
                                              },
                                              errorBuilder: (_, __, ___) =>
                                                  Center(
                                                child: Icon(
                                                    Icons.person_rounded,
                                                    size: 40,
                                                    color: mintColor),
                                              ),
                                            )
                                          : Center(
                                              child: Icon(Icons.person_rounded,
                                                  size: 40, color: mintColor),
                                            )),
                                ),
                                // Camera edit badge
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () => _pickAvatarImage(ctx),
                                    child: Container(
                                      width: 26,
                                      height: 26,
                                      decoration: BoxDecoration(
                                        color: mintColor,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: containerFill,
                                          width: 2,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.camera_alt_rounded,
                                        size: 13,
                                        color: isDark
                                            ? const Color(0xFF0B101D)
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 18),

                            // Username, Email, and Green "Verified member" checkmark badge
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    username,
                                    style: AppTypography.sansBold(context,
                                        fontSize: 19, color: textPrimary),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.mail_outline_rounded,
                                          size: 14, color: secondaryTextColor),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          email,
                                          style: AppTypography.sansSecondary(
                                              context,
                                              fontSize: 13,
                                              color: secondaryTextColor),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  // Green "Verified member" checkmark badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 9, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: mintColor.withOpacity(0.14),
                                      borderRadius: BorderRadius.circular(
                                          AppRadius.badge),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          isEmailVerified
                                              ? Icons.check_circle_rounded
                                              : Icons.person_outline_rounded,
                                          size: 13,
                                          color: mintColor,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          isEmailVerified
                                              ? "Verified member"
                                              : "Member",
                                          style: AppTypography.sansBold(
                                            context,
                                            fontSize: 11,
                                            color: mintColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 2. User Stats Row: 3 columns displaying real counts: "X Posts", "Y Returned", "Z Chats"
                      Container(
                        decoration: BoxDecoration(
                          color: containerFill,
                          borderRadius: BorderRadius.circular(AppRadius.card),
                          border: Border.all(color: borderColor, width: 1.2),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: Row(
                          children: [
                            _buildStatColumn(context, "$postsCount", "Posts",
                                textPrimary, secondaryTextColor),
                            Container(width: 1, height: 36, color: borderColor),
                            _buildStatColumn(context, "$returnedCount",
                                "Returned", mintColor, secondaryTextColor),
                            Container(width: 1, height: 36, color: borderColor),
                            _buildStatColumn(context, "$chatsCount", "Chats",
                                textPrimary, secondaryTextColor),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Section Header: ACTIVITY
                      Text(
                        "ACTIVITY",
                        style:
                            AppTypography.uppercaseLabel(context, fontSize: 11),
                      ),
                      const SizedBox(height: 8),

                      // 3. Activity Menu Card: Posts, bookmarks, drafts, notifications
                      Container(
                        decoration: BoxDecoration(
                          color: containerFill,
                          borderRadius: BorderRadius.circular(AppRadius.card),
                          border: Border.all(color: borderColor, width: 1.2),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            _buildMenuItem(
                              context: context,
                              icon: Icons.article_outlined,
                              title: "My posts",
                              badgeText: "$postsCount",
                              mintColor: mintColor,
                              textPrimary: textPrimary,
                              secondaryTextColor: secondaryTextColor,
                              onTap: () =>
                                  Navigator.of(context).pushNamed('/my-posts'),
                            ),
                            Divider(
                                height: 1, color: borderColor.withOpacity(0.5)),
                            _buildMenuItem(
                              context: context,
                              icon: Icons.bookmark_border_rounded,
                              title: "Saved items",
                              mintColor: mintColor,
                              textPrimary: textPrimary,
                              secondaryTextColor: secondaryTextColor,
                              onTap: () => Navigator.of(context)
                                  .pushNamed('/saved-items'),
                            ),
                            Divider(
                                height: 1, color: borderColor.withOpacity(0.5)),
                            _buildMenuItem(
                              context: context,
                              icon: Icons.edit_note_outlined,
                              title: "Drafts",
                              mintColor: mintColor,
                              textPrimary: textPrimary,
                              secondaryTextColor: secondaryTextColor,
                              onTap: () =>
                                  Navigator.of(context).pushNamed('/drafts'),
                            ),
                            Divider(
                                height: 1, color: borderColor.withOpacity(0.5)),
                            BlocBuilder<BadgeBloc, BadgeState>(
                              builder: (context, badgeState) => _buildMenuItem(
                                context: context,
                                icon: Icons.notifications_none_rounded,
                                title: "Notifications",
                                badgeText:
                                    "${badgeState.unreadNews + badgeState.unreadReceivedClaims}",
                                mintColor: mintColor,
                                textPrimary: textPrimary,
                                secondaryTextColor: secondaryTextColor,
                                onTap: () => Navigator.of(context)
                                    .pushNamed('/notifications'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Section Header: SETTINGS
                      Text(
                        "SETTINGS",
                        style:
                            AppTypography.uppercaseLabel(context, fontSize: 11),
                      ),
                      const SizedBox(height: 8),

                      // 4. Settings Menu Card: Dark theme toggle, Language, Change password
                      Container(
                        decoration: BoxDecoration(
                          color: containerFill,
                          borderRadius: BorderRadius.circular(AppRadius.card),
                          border: Border.all(color: borderColor, width: 1.2),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            // "Dark theme" item with a fully functional toggle switch
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 12.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: isDarkThemeActive
                                          ? mintColor.withOpacity(0.15)
                                          : const Color(0xFFF3EFEA),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      isDarkThemeActive
                                          ? Icons.dark_mode_rounded
                                          : Icons.light_mode_rounded,
                                      size: 20,
                                      color: isDarkThemeActive
                                          ? mintColor
                                          : const Color(0xFF1E232A),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Dark theme",
                                          style: AppTypography.sansBold(context,
                                              fontSize: 15, color: textPrimary),
                                        ),
                                        Text(
                                          isDarkThemeActive
                                              ? "Deep Midnight palette"
                                              : "Warm Ivory palette",
                                          style: AppTypography.sansSecondary(
                                              context,
                                              fontSize: 12,
                                              color: secondaryTextColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Switch(
                                    value: isDarkThemeActive,
                                    activeColor: mintColor,
                                    onChanged: (bool enabled) {
                                      appGlobalCtx.read<AppGlobalBloc>().add(
                                            AppGlobalEvent.themeChanged(enabled
                                                ? ThemeMode.dark
                                                : ThemeMode.light),
                                          );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                                height: 1, color: borderColor.withOpacity(0.5)),

                            // "Language" item showing active selection ("English")
                            _buildMenuItem(
                              context: context,
                              icon: Icons.language_rounded,
                              title: "Language",
                              trailingText:
                                  appGlobalState.locale.languageCode == "it"
                                      ? "Italiano"
                                      : "English",
                              mintColor: mintColor,
                              textPrimary: textPrimary,
                              secondaryTextColor: secondaryTextColor,
                              onTap: () => _showLanguageSheet(
                                  context, appGlobalState.locale),
                            ),
                            Divider(
                                height: 1, color: borderColor.withOpacity(0.5)),

                            // "Change password" item wired to password reset flow
                            _buildMenuItem(
                              context: context,
                              icon: Icons.lock_outline_rounded,
                              title: "Change password",
                              mintColor: mintColor,
                              textPrimary: textPrimary,
                              secondaryTextColor: secondaryTextColor,
                              onTap: () => Navigator.of(context)
                                  .pushNamed('/options/changePassword'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Log Out Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton(
                          onPressed: () => _showLogoutDialog(context, ctx),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: Color(0xFFA61C32), width: 1.2),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.button)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.logout_rounded,
                                  size: 18, color: Color(0xFFA61C32)),
                              const SizedBox(width: 8),
                              Text(
                                "Log out",
                                style: AppTypography.sansBold(context,
                                    fontSize: 15,
                                    color: const Color(0xFFA61C32)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatColumn(
    BuildContext context,
    String count,
    String label,
    Color countColor,
    Color labelColor,
  ) {
    return Expanded(
      child: Column(
        children: [
          Text(
            count,
            style: AppTypography.serifHeading(context,
                fontSize: 24, color: countColor),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTypography.sansSecondary(context,
                fontSize: 12, color: labelColor),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color mintColor,
    required Color textPrimary,
    required Color secondaryTextColor,
    required VoidCallback onTap,
    String? badgeText,
    String? trailingText,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          child: Row(
            children: [
              Icon(icon, size: 22, color: textPrimary),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.sansBold(context,
                      fontSize: 15, color: textPrimary),
                ),
              ),
              if (badgeText != null && badgeText != "0")
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: mintColor.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(AppRadius.badge),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: mintColor,
                    ),
                  ),
                ),
              if (trailingText != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    trailingText,
                    style: AppTypography.sansSecondary(context,
                        fontSize: 13, color: secondaryTextColor),
                  ),
                ),
              Icon(Icons.chevron_right_rounded,
                  size: 22, color: secondaryTextColor),
            ],
          ),
        ),
      ),
    );
  }
}
