import 'package:lost_and_found/core/data/datasources/app_global/models/ip_details_dto.dart';
import 'package:lost_and_found/core/domain/usecases/usecase.dart';

abstract class AppGlobalDataSource {
  Future<IpDetailsDto> getCurrentCountry(NoParams params);
}

class AppGlobalDataSourceImpl implements AppGlobalDataSource {
  AppGlobalDataSourceImpl();

  @override
  Future<IpDetailsDto> getCurrentCountry(NoParams params) async {
    return const IpDetailsDto(countryCode: 'en');
  }
}
