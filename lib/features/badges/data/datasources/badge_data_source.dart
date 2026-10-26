import 'package:lost_and_found/core/domain/usecases/usecase.dart';

abstract class BadgeDataSource {
  Future<List<int>> getUnreadNews(NoParams params);

  Future<List<int>> getUnreadReceivedClaims(NoParams params);
}

class BadgeDataSourceImpl implements BadgeDataSource {
  BadgeDataSourceImpl();

  @override
  Future<List<int>> getUnreadNews(NoParams params) async {
    return const [];
  }

  @override
  Future<List<int>> getUnreadReceivedClaims(NoParams params) async {
    return const [];
  }
}
