import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:lost_and_found/core/presentation/widgets/custom_circular_progress.dart';
import 'package:lost_and_found/core/presentation/widgets/error_page.dart';
import 'package:lost_and_found/features/chat/presentation/bloc/chat/chat_bloc.dart'
    as chat;
import 'package:lost_and_found/features/claim/domain/entities/claim_received.dart';
import 'package:lost_and_found/features/claim/domain/entities/claim_sent.dart'
    as sent;
import 'package:lost_and_found/features/claim/presentation/bloc/claim/claim_bloc.dart';
import 'package:lost_and_found/features/claim/presentation/widgets/claim/not_claimed_item_card.dart';
import 'package:lost_and_found/utils/constants.dart';

import '../../../../core/presentation/widgets/circular_image_avatar.dart';
import '../../../../injection_container.dart';
import '../../../../utils/colors/custom_color.dart';
import '../../../claim/presentation/widgets/claim/claimed_item_card.dart';
import '../../../claim/presentation/widgets/claim/claimed_status_card.dart';

class ChatScreen extends StatelessWidget {
  final String roomId;
  final int itemId;

  const ChatScreen({
    super.key,
    required this.roomId,
    required this.itemId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<chat.ChatBloc>(
            create: (_) => sl<chat.ChatBloc>()
              ..add(chat.ChatEvent.chatContentCreated(roomId, itemId))),
        BlocProvider<ClaimBloc>(create: (_) => sl<ClaimBloc>())
      ],
      child: BlocBuilder<chat.ChatBloc, chat.ChatState>(
        builder: (ctx, state) {
          if (state.hasLoadingError) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor:
                    Theme.of(context).extension<CustomColors>()!.background2,
                elevation: 0,
                surfaceTintColor: Theme.of(context).colorScheme.outline,
                shadowColor: Theme.of(context).colorScheme.outline,
                iconTheme: IconThemeData(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              body: SafeArea(
                child: ErrorPage(
                    onRetry: () => ctx.read<chat.ChatBloc>().add(
                        chat.ChatEvent.chatContentCreated(roomId, itemId))),
              ),
            );
          }

          if (state.isLoading || state.room == null) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor:
                    Theme.of(context).extension<CustomColors>()!.background2,
                elevation: 0,
                surfaceTintColor: Theme.of(context).colorScheme.outline,
                shadowColor: Theme.of(context).colorScheme.outline,
                iconTheme: IconThemeData(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              body: const SafeArea(
                child: CustomCircularProgress(size: 100),
              ),
            );
          }

          final room = state.room!;
          final currentUid = FirebaseAuth.instance.currentUser?.uid;
          types.User? currentUser;
          types.User? otherUser;
          for (final user in room.users) {
            if (user.id == currentUid) {
              currentUser = user;
            } else {
              otherUser ??= user;
            }
          }
          if (currentUser == null || otherUser == null) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(
                  child:
                      Text('This conversation has invalid participant data.')),
            );
          }
          final signedInUser = currentUser;
          final conversationPartner = otherUser;

          final matchingClaims = state.item!.claims?.where(
              (claim) => claim.user.username == conversationPartner.firstName);
          final receivedClaim =
              matchingClaims != null && matchingClaims.isNotEmpty
                  ? matchingClaims.first
                  : null;
          final sentClaim = state.item!.userClaim;

          return WillPopScope(
            onWillPop: () async {
              ctx.read<chat.ChatBloc>().add(const chat.ChatEvent.chatRead());
              return true;
            },
            child: Scaffold(
              appBar: AppBar(
                backgroundColor:
                    Theme.of(context).extension<CustomColors>()!.background2,
                elevation: 0,
                surfaceTintColor: Theme.of(context).colorScheme.outline,
                shadowColor: Theme.of(context).colorScheme.outline,
                title: Text(conversationPartner.firstName ?? 'Conversation',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 18)),
                iconTheme: IconThemeData(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    StreamBuilder<String?>(
                      stream: ctx.read<chat.ChatBloc>().sendErrors,
                      builder: (context, snapshot) {
                        if (snapshot.data == null)
                          return const SizedBox.shrink();
                        return MaterialBanner(
                          content: Text(snapshot.data!),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  ctx.read<chat.ChatBloc>().dismissSendError(),
                              child: const Text('Dismiss'),
                            ),
                          ],
                        );
                      },
                    ),
                    if (MediaQuery.of(context).orientation !=
                        Orientation.landscape)
                      receivedClaim != null
                          ? Container(
                              color: Theme.of(context).colorScheme.background,
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 2),
                              child: ClaimedItemCard(
                                isItemResolved: state.item!.resolved,
                                token: state.token,
                                claim: ClaimReceived(
                                  id: receivedClaim.id,
                                  item: ReceivedItem(
                                      id: state.item!.id,
                                      title: state.item!.title),
                                  user: ReceivedUser(
                                      id: receivedClaim.user.id,
                                      username: receivedClaim.user.username),
                                  status: receivedClaim.status,
                                  opened: receivedClaim.opened,
                                ),
                              ),
                            )
                          : Container(
                              color: Theme.of(context).colorScheme.background,
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 2),
                              child: sentClaim != null
                                  ? ClaimedStatusCard(
                                      claim: sent.ClaimSent(
                                          status: sentClaim.status,
                                          id: sentClaim.id,
                                          item: sent.SentItem(
                                              id: state.item!.id,
                                              title: state.item!.title)),
                                      token: state.token,
                                      isItemSolved: state.item!.resolved,
                                    )
                                  : NotClaimedItemCard(
                                      isItemSolved: state.item!.resolved,
                                      itemId: state.item!.id,
                                      itemName: state.item!.title,
                                      token: state.token,
                                    ),
                            ),
                    Expanded(
                      child: StreamBuilder<List<types.Message>>(
                        initialData: const [],
                        stream: state.messages,
                        builder: (context, snapshot) => Chat(
                          showUserAvatars: true,
                          avatarBuilder: (userId) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: _buildUserAvatar(userId.id, state.token),
                            );
                          },
                          theme: DefaultChatTheme(
                            inputBorderRadius:
                                const BorderRadius.all(Radius.circular(16)),
                            inputContainerDecoration: BoxDecoration(
                                color: Theme.of(context)
                                    .extension<CustomColors>()!
                                    .background2,
                                border: Border.all(
                                    width: 1,
                                    color: Theme.of(context)
                                        .extension<CustomColors>()!
                                        .secondaryTextColor!),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16))),
                            primaryColor:
                                Theme.of(context).colorScheme.onTertiary,
                            secondaryColor:
                                Theme.of(context).colorScheme.tertiaryContainer,
                            receivedMessageBodyTextStyle: TextStyle(
                                fontSize: 16,
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                            sentMessageBodyTextStyle: TextStyle(
                                fontSize: 16,
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                            inputBackgroundColor:
                                Theme.of(context).colorScheme.background,
                            inputTextColor:
                                Theme.of(context).colorScheme.onBackground,
                            inputTextStyle: const TextStyle(fontSize: 16),
                            inputTextDecoration: const InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.background,
                            inputPadding:
                                const EdgeInsets.fromLTRB(16, 12, 16, 12),
                            inputMargin: const EdgeInsets.all(8),
                          ),
                          messages: snapshot.data ?? [],
                          onSendPressed: (message) => ctx
                              .read<chat.ChatBloc>()
                              .add(chat.ChatEvent.messageSent(message)),
                          user: signedInUser,
                          //showUserAvatars: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserAvatar(String userId, String token) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
      builder: (context, snapshot) {
        final imageUrl = (snapshot.data?.data()?['photoUrl'] as String? ??
                snapshot.data?.data()?['imageUrl'] as String?) ??
            '';

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.only(right: 10),
            child: CustomCircularProgress(size: 20),
          );
        }

        return CircularImage(
          errorImage: noUserImagePath,
          token: token,
          imageUrl: imageUrl,
          radius: 20,
        );
      },
    );
  }
}
