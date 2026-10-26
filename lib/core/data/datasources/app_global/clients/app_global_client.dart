import 'package:lost_and_found/core/data/datasources/app_global/models/ip_details_dto.dart';

abstract class AppGlobalClient {
  Future<IpDetailsDto> getCurrentCountryInfo();
}

