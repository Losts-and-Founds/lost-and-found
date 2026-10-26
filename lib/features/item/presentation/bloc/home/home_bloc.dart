import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lost_and_found/core/data/secure_storage/secure_storage.dart';
import 'package:lost_and_found/features/item/domain/entities/user_item.dart';
import 'package:lost_and_found/features/item/domain/usecases/get_user_items_usecase.dart';

part 'home_bloc.freezed.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetUserItemsUseCase _getUserItemsUseCase;
  final SecureStorage _secureStorage;

  HomeBloc(
      {required GetUserItemsUseCase getUserItemsUseCase,
      required SecureStorage secureStorage})
      : _getUserItemsUseCase = getUserItemsUseCase,
        _secureStorage = secureStorage,
        super(HomeState.initial()) {
    on<HomeEvent>(
      (event, emit) async {
        await event.when<FutureOr<void>>(
          homeCreated: () => _onHomeCreatedOrRefreshed(emit, preferCache: true),
          homeRefreshed: () => _onHomeCreatedOrRefreshed(emit),
          homeSectionRefreshed: (type) => _onHomeSectionRefreshed(emit, type),
          restoreInitial: () => emit(HomeState.initial()),
        );
      },
    );
  }

  Future<void> _onHomeCreatedOrRefreshed(
    Emitter<HomeState> emit, {
    bool preferCache = false,
  }) async {
    emit(state.copyWith(hasLoadingError: false, isLoading: true));

    final responses = await Future.wait([
      _getUserItemsUseCase(
          GetUserItemsParams(type: ItemType.found, preferCache: preferCache)),
      _getUserItemsUseCase(
          GetUserItemsParams(type: ItemType.lost, preferCache: preferCache)),
    ]);
    final foundItemsResponse = responses[0];
    final lostItemsResponse = responses[1];

    final session = await _secureStorage.getSessionInformation();

    final foundItems = foundItemsResponse.getOrElse(() => state.foundItems);

    emit(
      state.copyWith(
          lostItems: lostItemsResponse.getOrElse(() => state.lostItems),
          foundItems: foundItems,
          hasLoadingError:
              foundItemsResponse.isLeft() || lostItemsResponse.isLeft(),
          token: session != null ? session.token : ""),
    );

    emit(state.copyWith(isLoading: false));
  }

  Future<void> _onHomeSectionRefreshed(
      Emitter<HomeState> emit, ItemType type) async {
    final itemsResponse =
        await _getUserItemsUseCase(GetUserItemsParams(type: type));

    if (itemsResponse.isRight()) {
      if (type == ItemType.found) {
        final foundItems = itemsResponse.getOrElse(() => state.foundItems);

        emit(state.copyWith(foundItems: foundItems, hasLoadingError: false));
      } else {
        emit(state.copyWith(
          lostItems: itemsResponse.getOrElse(() => state.lostItems),
          hasLoadingError: false,
        ));
      }
    }
  }
}
