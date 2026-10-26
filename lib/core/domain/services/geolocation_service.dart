import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/status/failures.dart';

class GeoLocationService {
  const GeoLocationService();

  Future<Either<Failure, Position>> getGeoPosition(bool askPermission) async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied && askPermission) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return const Left(Failure.geolocationFailure(GeolocationError.permissionDenied));
        } else if (permission == LocationPermission.deniedForever) {
          return const Left(Failure.geolocationFailure(GeolocationError.permissionPermanentlyDenied));
        }
      }

      if (permission == LocationPermission.deniedForever && askPermission) {
        return const Left(Failure.geolocationFailure(GeolocationError.permissionPermanentlyDenied));
      }

      // 1. Try fast last known position first for instant response
      final lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null) {
        return Right(lastKnown);
      }

      // 2. If service is not enabled, return serviceNotAvailable
      if (!serviceEnabled) {
        return const Left(Failure.geolocationFailure(GeolocationError.serviceNotAvailable));
      }

      // 3. Fast location lookup with 4s timeout and medium accuracy
      final current = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 4),
      );
      return Right(current);
    } catch (_) {
      // Graceful fallback to last known or university campus position
      final lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null) {
        return Right(lastKnown);
      }
      return Right(Position(
        longitude: 11.8768,
        latitude: 45.4064,
        timestamp: DateTime.now(),
        accuracy: 10.0,
        altitude: 0.0,
        altitudeAccuracy: 0.0,
        heading: 0.0,
        headingAccuracy: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      ));
    }
  }
}
