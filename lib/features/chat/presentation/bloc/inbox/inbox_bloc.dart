import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lost_and_found/core/domain/usecases/usecase.dart';

import '../../../../../core/data/secure_storage/secure_storage.dart';
import '../../../domain/usecases/get_user_rooms_usecase.dart';

part 'inbox_bloc.freezed.dart';

part 'inbox_event.dart';

part 'inbox_state.dart';

class InboxBloc extends Bloc<InboxEvent, InboxState> {
  final GetUserRoomsUseCase _getUserRoomsUseCase;
  final SecureStorage _storage;

  InboxBloc({
    required GetUserRoomsUseCase getUserRoomsUseCase,
    required SecureStorage storage,
  })  : _getUserRoomsUseCase = getUserRoomsUseCase,
        _storage = storage,
        super(InboxState.initial()) {
    on<InboxEvent>(
      (event, emit) async {
        await event.when<FutureOr<void>>(
          inboxContentCreated: () => _onInboxContentCreated(emit),
          restoreInitial: () => emit(InboxState.initial()),
        );
      },
    );
  }

  Future<void> _onInboxContentCreated(Emitter<InboxState> emit) async {
    emit(state.copyWith(isLoading: true, hasLoginOrLoadingError: false));

    try {
      final roomsResponse = await _getUserRoomsUseCase(NoParams());
      if (roomsResponse.isLeft()) {
        emit(state.copyWith(
          isLoading: false,
          hasLoginOrLoadingError: true,
        ));
        return;
      }

      final session = await _storage
          .getSessionInformation()
          .timeout(const Duration(seconds: 5))
          .catchError((Object error, StackTrace stackTrace) {
        log(
          'Could not load optional inbox session metadata.',
          error: error,
          stackTrace: stackTrace,
        );
        return null;
      });

      emit(state.copyWith(
        isLoading: false,
        hasLoginOrLoadingError: false,
        userRooms: roomsResponse.getOrElse(() => const Stream.empty()),
        token: session?.token ?? '',
        currentId: session?.user ?? 0,
      ));
    } catch (error, stackTrace) {
      log(
        'Could not initialize inbox.',
        error: error,
        stackTrace: stackTrace,
      );
      emit(state.copyWith(
        isLoading: false,
        hasLoginOrLoadingError: true,
      ));
    }
  }
}
