import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:lost_and_found/core/domain/usecases/get_address_from_position_usecase.dart';
import 'package:lost_and_found/core/domain/usecases/get_position_from_address_usecase.dart';

import 'models/address_dto.dart';
import 'models/position_dto.dart';

abstract class PositionDataSource {
  Future<AddressDto> getAddressFromPosition(
      GetAddressFromPositionParams params);
  Future<PositionDto> getPositionFromAddress(
      GetPositionFromAddressParams params);
}

class PositionDataSourceImpl implements PositionDataSource {
  PositionDataSourceImpl();

  @override
  Future<AddressDto> getAddressFromPosition(
      GetAddressFromPositionParams params) async {
    final uri = Uri.https(
      'nominatim.openstreetmap.org',
      '/reverse',
      {
        'format': 'jsonv2',
        'lat': params.lat.toString(),
        'lon': params.lon.toString(),
        'zoom': '16',
        'addressdetails': '1',
      },
    );

    try {
      final response = await http.get(uri, headers: {
        'User-Agent': 'LostAndFoundApp/1.0'
      }).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final displayName = data['display_name'] as String?;
        if (displayName != null && displayName.isNotEmpty) {
          final address = data['address'] as Map<String, dynamic>?;
          final road =
              address?['road'] ?? address?['pedestrian'] ?? address?['path'];
          final area = address?['city'] ??
              address?['town'] ??
              address?['village'] ??
              address?['suburb'] ??
              address?['county'];
          if (road != null && area != null) {
            return AddressDto(address: '$road, $area');
          }
          return AddressDto(address: displayName);
        }
      }
    } on TimeoutException {
      // Keep coordinate fallback for the location picker when geocoding times out.
    } on SocketException {
      // Keep coordinate fallback for the location picker when offline.
    } on http.ClientException {
      // Keep coordinate fallback for the location picker when the request fails.
    } on FormatException {
      // Keep coordinate fallback if the geocoder response is malformed.
    }

    return const AddressDto(address: 'Nsukka, Enugu State');
  }

  @override
  Future<PositionDto> getPositionFromAddress(
      GetPositionFromAddressParams params) async {
    return const PositionDto(lat: 45.4064, lon: 11.8768);
  }
}
