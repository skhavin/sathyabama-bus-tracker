import 'dart:async';

import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:geolocator/geolocator.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  StreamSubscription<Position>? _positionStream;

  Future<bool> requestPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<Position?> getCurrentPosition() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return null;
      }
      final hasPermission = await requestPermissions();
      if (!hasPermission) {
        return null;
      }

      // Android: Google Play Fused location often surfaces
      // [PositionUpdateException] ("listening for position updates").
      // Prefer legacy LocationManager + fallbacks.
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
        Future<Position?> tryFix({
          required LocationAccuracy accuracy,
          Duration? timeLimit,
        }) async {
          try {
            return await Geolocator.getCurrentPosition(
              desiredAccuracy: accuracy,
              forceAndroidLocationManager: true,
              timeLimit: timeLimit,
            );
          } catch (_) {
            return null;
          }
        }

        return await tryFix(
              accuracy: LocationAccuracy.high,
              timeLimit: const Duration(seconds: 30),
            ) ??
            await tryFix(
              accuracy: LocationAccuracy.medium,
              timeLimit: const Duration(seconds: 20),
            ) ??
            await tryFix(
              accuracy: LocationAccuracy.low,
              timeLimit: const Duration(seconds: 15),
            ) ??
            await Geolocator.getLastKnownPosition(
              forceAndroidLocationManager: true,
            );
      }

      try {
        return await Geolocator.getCurrentPosition(
          desiredAccuracy:
              kIsWeb ? LocationAccuracy.medium : LocationAccuracy.high,
          forceAndroidLocationManager: false,
          timeLimit: Duration(seconds: kIsWeb ? 25 : 30),
        );
      } catch (_) {
        if (!kIsWeb) {
          return await Geolocator.getLastKnownPosition(
            forceAndroidLocationManager: false,
          );
        }
        return null;
      }
    } catch (e) {
      print('Error getting current position: $e');
      return null;
    }
  }

  void startTracking(Function(Position) onLocationUpdate) {
    final LocationSettings settings;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      settings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
        forceLocationManager: true,
      );
    } else if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      settings = AppleSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
        activityType: ActivityType.otherNavigation,
      );
    } else {
      settings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );
    }

    _positionStream = Geolocator.getPositionStream(
      locationSettings: settings,
    ).listen(
      onLocationUpdate,
      onError: (Object e, StackTrace st) {
        print('Location stream error: $e');
      },
    );
  }

  void stopTracking() {
    _positionStream?.cancel();
    _positionStream = null;
  }

  double calculateSpeed(Position position) {
    return position.speed;
  }
}
