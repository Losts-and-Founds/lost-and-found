import 'package:dartz/dartz.dart';
import 'package:lost_and_found/features/item/domain/repositories/item_repository.dart';

import '../../../../core/domain/usecases/usecase.dart';
import '../../../../core/status/failures.dart';
import '../entities/search_item.dart';

class SearchItemsUseCase
    implements UseCase<List<SearchItem>, SearchItemsParams> {
  final ItemRepository repository;

  SearchItemsUseCase(this.repository);

  @override
  Future<Either<Failure, List<SearchItem>>> call(
      SearchItemsParams params) async {
    return await repository.searchItems(params);
  }
}

class SearchItemsParams {
  final int rangeMeters;
  final double? latitude;
  final double? longitude;
  final SearchItemType type;
  final int? categoryId;
  final DateTime? date;

  SearchItemsParams(
      {required this.rangeMeters,
      required this.latitude,
      required this.longitude,
      required this.type,
      required this.categoryId,
      required this.date});
}

enum SearchItemType { found, lost, all }
