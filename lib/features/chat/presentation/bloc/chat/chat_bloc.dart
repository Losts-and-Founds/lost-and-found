import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lost_and_found/features/chat/domain/usecases/get_room_messages_usecase.dart';
import 'package:lost_and_found/features/chat/domain/usecases/read_chat_usecase.dart';
import 'package:lost_and_found/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:lost_and_found/features/item/domain/usecases/get_item_usecase.dart';

import '../../../../../core/data/secure_storage/secure_storage.dart';
import '../../../../item/domain/entities/item.dart';

part 'chat_bloc.freezed.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetRoomMessagesUseCase _getRoomMessagesUseCase;
  final GetItemUseCase _getItemUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final ReadChatUseCase _readChatUseCase;

  final SecureStorage _storage;
  final StreamController<String?> _sendErrors =
      StreamController<String?>.broadcast();

  Stream<String?> get sendErrors => _sendErrors.stream;

  void dismissSendError() => _sendErrors.add(null);

  ChatBloc(
      {required GetRoomMessagesUseCase getRoomMessagesUseCase,
      required GetItemUseCase getItemUseCase,
      required SendMessageUseCase sendMessageUseCase,
      required ReadChatUseCase readChatUseCase,
      required SecureStorage storage})
      : _getRoomMessagesUseCase = getRoomMessagesUseCase,
        _getItemUseCase = getItemUseCase,
        _sendMessageUseCase = sendMessageUseCase,
        _readChatUseCase = readChatUseCase,
        _storage = storage,
        super(ChatState.initial()) {
    on<ChatEvent>(
      (event, emit) async {
        await event.when<FutureOr<void>>(
          chatContentCreated: (roomId, itemId) =>
              _onInboxContentCreated(emit, roomId, itemId),
          messageSent: (message) => _onMessageSent(message),
          chatRead: () => _onChatRead(),
        );
      },
    );
  }

  Future<void> _onChatRead() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null || state.room == null) return;

    await _readChatUseCase(
        ReadChatParams(currentId: userId, roomId: state.room!.id));
  }

  Future<void> _onMessageSent(PartialText message) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null || state.room == null) {
      _sendErrors
          .add('You are no longer signed in. Please sign in and try again.');
      return;
    }

    final response = await _sendMessageUseCase(SendMessageParams(
      message: message,
      roomId: state.room!.id,
      senderId: userId,
    ));
    response.fold(
        (failure) =>
            _sendErrors.add('Message could not be sent. Please try again.'),
        (_) {});
  }

  Future<void> _onInboxContentCreated(
      Emitter<ChatState> emit, roomId, itemId) async {
    emit(state.copyWith(isLoading: true));

    final messagesResponse =
        await _getRoomMessagesUseCase(GetRoomMessagesParams(roomId: roomId));
    final itemResponse = await _getItemUseCase(GetItemParams(id: itemId));
    final session = await _storage.getSessionInformation();

    Room? room;
    Stream<List<Message>> messages = const Stream.empty();

    messagesResponse.fold((_) {}, (pair) {
      room = pair.first;
      messages = pair.second;
    });

    emit(
      state.copyWith(
          isLoading: false,
          messages: messages,
          room: room,
          hasLoadingError: messagesResponse.isLeft() || itemResponse.isLeft(),
          token: session?.token ?? "",
          currentUsername: session?.username,
          item: itemResponse.fold((_) => null, (item) => item)),
    );

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (room != null && userId != null) {
      final readResponse = await _readChatUseCase(
        ReadChatParams(currentId: userId, roomId: room!.id),
      );
      readResponse.fold(
        (_) =>
            _sendErrors.add('Could not update the conversation read status.'),
        (_) {},
      );
    }
  }

  @override
  Future<void> close() async {
    await _sendErrors.close();
    await super.close();
  }
}
