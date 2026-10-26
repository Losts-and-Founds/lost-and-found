import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:lost_and_found/core/data/secure_storage/secure_storage.dart';
import 'package:lost_and_found/core/domain/usecases/get_address_from_position_usecase.dart';
import 'package:lost_and_found/features/item/domain/entities/user_item.dart';
import 'package:lost_and_found/features/item/domain/fields/insert_item/position.dart';
import 'package:lost_and_found/features/item/domain/usecases/create_item_usecase.dart';

import '../../../../../core/status/failures.dart';
import '../../../../../core/status/success.dart';
import '../../../../../utils/constants.dart';
import '../../../domain/fields/insert_item/category.dart';
import '../../../domain/fields/insert_item/question.dart';
import '../../../domain/fields/insert_item/title.dart';
import '../../../domain/usecases/upload_item_image_usecase.dart';

part 'insert_item_bloc.freezed.dart';

part 'insert_item_event.dart';

part 'insert_item_state.dart';

class InsertItemBloc extends Bloc<InsertItemEvent, InsertItemState> {
  final CreateItemUseCase _createItemUseCase;
  final UploadItemImageUseCase _uploadItemImageUseCase;
  final GetAddressFromPositionUseCase _getAddressFromPositionUseCase;
  final SecureStorage _storage;
  String? _pendingElectronicsDeviceType;
  String? _pendingElectronicsIdentifier;
  String? _pendingLocationLabel;

  InsertItemBloc({
    required CreateItemUseCase createItemUseCase,
    required UploadItemImageUseCase uploadItemImageUseCase,
    required GetAddressFromPositionUseCase getAddressFromPositionUseCase,
    required SecureStorage storage,
  })  : _createItemUseCase = createItemUseCase,
        _uploadItemImageUseCase = uploadItemImageUseCase,
        _getAddressFromPositionUseCase = getAddressFromPositionUseCase,
        _storage = storage,
        super(InsertItemState.initial()) {
    on<InsertItemEvent>(
      (event, emit) async {
        await event.when<FutureOr<void>>(
          imageSelected: (image) => _onImageChanged(emit, image),
          imageDeleted: () => _onImageChanged(emit, null),
          typeChanged: (type) => _onTypeChanged(emit, type),
          titleChanged: (input) => _onTitleChanged(emit, input),
          questionChanged: (input) => _onQuestionChanged(emit, input),
          positionSelected: (pos) => _onPositionSelected(emit, pos),
          categorySelected: (catId, category) =>
              _onCategoryChanged(emit, catId, category),
          insertSubmitted: () => _onInsertSubmitted(emit),
          contentCreated: (isNewItemLost) =>
              _onContentCreated(emit, isNewItemLost),
          onImagePicking: () => _onImagePicking(),
        );
      },
    );
  }

  Future<void> _onImagePicking() async {
    await _storage.saveLastPickingOperation(ImagePick.insertItem.name);
  }

  Future<void> _onContentCreated(
      Emitter<InsertItemState> emit, bool isNewItemLost) async {
    if (Platform.isAndroid) {
      final lastPickedImageAction = await _storage.getLastPickingOperation();
      final lastPickedData = await ImagePicker().retrieveLostData();

      if (lastPickedImageAction != null &&
          lastPickedImageAction == ImagePick.insertItem.name &&
          lastPickedData.file != null) {
        emit(state.copyWith(imagePath: lastPickedData.file!.path));
      }
    }

    emit(state.copyWith(type: isNewItemLost ? ItemType.lost : ItemType.found));
  }

  void _onCategoryChanged(
      Emitter<InsertItemState> emit, int catId, String category) {
    emit(state.copyWith(cat: CategoryField(catId), category: category));
  }

  void _onImageChanged(Emitter<InsertItemState> emit, String? image) {
    emit(state.copyWith(imagePath: image));
  }

  void _onTypeChanged(Emitter<InsertItemState> emit, ItemType? type) {
    if (type != null) {
      emit(state.copyWith(type: type));
    }
  }

  void _onTitleChanged(Emitter<InsertItemState> emit, String input) {
    emit(state.copyWith(title: TitleField(input)));
  }

  void _onQuestionChanged(Emitter<InsertItemState> emit, String input) {
    emit(state.copyWith(question: QuestionField(input)));
  }

  void submit({
    String? electronicsDeviceType,
    String? electronicsIdentifier,
    String? locationLabel,
  }) {
    _pendingElectronicsDeviceType = electronicsDeviceType;
    _pendingElectronicsIdentifier = electronicsIdentifier;
    _pendingLocationLabel = locationLabel;
    add(const InsertItemEvent.insertSubmitted());
  }

  Future<void> _onInsertSubmitted(Emitter<InsertItemState> emit) async {
    final electronicsDeviceType = _pendingElectronicsDeviceType;
    final electronicsIdentifier = _pendingElectronicsIdentifier;
    final locationLabel = _pendingLocationLabel;
    _pendingElectronicsDeviceType = null;
    _pendingElectronicsIdentifier = null;
    _pendingLocationLabel = null;

    emit(state.copyWith(isSubmitting: true));

    final isItemLostValid = state.title.value.isRight();
    final isItemFoundValid =
        state.title.value.isRight() && state.question.value.isRight();
    final isCategoryValid = state.cat.value.isRight();

    Either<Failure, Success>? createFailureOrSuccess;
    Either<Failure, Success>? imageFailureOrSuccess;
    int? newItemId;
    final requiresElectronicsIdentifier =
        state.cat.value.getOrElse(() => -1) == 2;
    final hasValidElectronicsIdentifier = !requiresElectronicsIdentifier ||
        (electronicsDeviceType != null &&
            (electronicsDeviceType == 'phone' ||
                electronicsDeviceType == 'laptop') &&
            (electronicsIdentifier?.trim().isNotEmpty ?? false));

    if ((isItemLostValid || isItemFoundValid) &&
        isCategoryValid &&
        hasValidElectronicsIdentifier) {
      emit(state.copyWith(isLoading: true, insertFailureOrSuccess: null));

      final hasPosition = state.pos.value.isRight();
      final pos = state.pos.value.getOrElse(() => const LatLng(0, 0));

      final params = CreateItemParams(
        category: state.cat.value.getOrElse(() => 0),
        title: state.title.value.getOrElse(() => ""),
        question: state.type == ItemType.found
            ? state.question.value.getOrElse(() => "")
            : null,
        type: state.type,
        position: Position(X: pos.latitude, Y: pos.longitude),
        locationLabel: hasPosition && state.address.isNotEmpty
            ? state.address
            : (locationLabel?.isNotEmpty ?? false)
                ? locationLabel
                : null,
        electronicsDeviceType:
            requiresElectronicsIdentifier ? electronicsDeviceType : null,
        electronicsIdentifier:
            requiresElectronicsIdentifier ? electronicsIdentifier : null,
      );

      final insertResponse = await _createItemUseCase(params);
      insertResponse.fold((failure) => createFailureOrSuccess = Left(failure),
          (itemId) {
        createFailureOrSuccess = const Right(Success.genericSuccess());
        newItemId = itemId;
      });

      if (newItemId != null && state.imagePath != null) {
        final params = UploadItemImageParams(
            itemId: newItemId!, image: File(state.imagePath!));

        final imgFailureOrSuccess = await _uploadItemImageUseCase(params);
        imgFailureOrSuccess.fold(
            (failure) => imageFailureOrSuccess = Left(failure),
            (success) => imageFailureOrSuccess = Right(success));

        if (imgFailureOrSuccess.isRight()) {
          _storage.saveLastPickingOperation(ImagePick.nothing.name);
        }
      }
    } else if (!hasValidElectronicsIdentifier) {
      createFailureOrSuccess = const Left(Failure.validationFailure());
    }

    emit(
      state.copyWith(
        showError: true,
        insertFailureOrSuccess: createFailureOrSuccess,
        imageUploadFailureOrSuccess: imageFailureOrSuccess,
        isSubmitting: false,
      ),
    );

    emit(state.copyWith(
        insertFailureOrSuccess: null, imageUploadFailureOrSuccess: null));
  }

  Future<void> _onPositionSelected(
      Emitter<InsertItemState> emit, LatLng pos) async {
    emit(state.copyWith(isLoadingPosition: true));

    final addressOrFailure = await _getAddressFromPositionUseCase(
        GetAddressFromPositionParams(lat: pos.latitude, lon: pos.longitude));

    addressOrFailure.fold(
        (failure) => emit(state.copyWith(
              address: 'Nsukka, Enugu State',
              pos: PositionField(pos),
              isLoadingPosition: false,
            )),
        (address) => emit(state.copyWith(
            address: _looksLikeCoordinates(address)
                ? 'Nsukka, Enugu State'
                : address,
            pos: PositionField(pos),
            isLoadingPosition: false)));
  }

  bool _looksLikeCoordinates(String value) {
    final parts = value.split(',');
    return parts.length == 2 &&
        double.tryParse(parts[0].trim()) != null &&
        double.tryParse(parts[1].trim()) != null;
  }
}
