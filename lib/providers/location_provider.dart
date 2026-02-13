import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider extends ChangeNotifier {
  // 👉 Punto de crisis (el mismo del mapa)
  final LatLng target = const LatLng(-4.007021, -79.204329);

  Position? currentPosition;

  double distance = 999;
  double accuracy = 999;

  StreamSubscription<Position>? _sub;

  int gpsRequests = 0;

  bool get canUseCamera => accuracy <= 20;
  LocationAccuracy _currentAccuracy = LocationAccuracy.medium;

  // ----------------------------------------------------

  void startTracking() {
    LocationSettings settings = const LocationSettings(
      accuracy: LocationAccuracy.medium,
      distanceFilter: 5,
    );

    _sub = Geolocator.getPositionStream(locationSettings: settings).listen((
      pos,
    ) {
      gpsRequests++;

      currentPosition = pos;
      accuracy = pos.accuracy;

      distance = Geolocator.distanceBetween(
        pos.latitude,
        pos.longitude,
        target.latitude,
        target.longitude,
      );

      _updateTrackingMode();

      notifyListeners();
    });
  }

  // ----------------------------------------------------
  // ahorro de batería según distancia

  void _updateTrackingMode() {
    if (distance > 100) {
      _restartStream(
        const LocationSettings(
          accuracy: LocationAccuracy.low,
          distanceFilter: 20,
        ),
      );
    } else if (distance > 20) {
      _restartStream(
        const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5,
        ),
      );
    } else {
      _restartStream(
        const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 1,
        ),
      );
    }
  }

  void _restartStream(LocationSettings settings) async {
    if (settings.accuracy == _currentAccuracy) return;

    _currentAccuracy = settings.accuracy;

    await _sub?.cancel();

    _sub = Geolocator.getPositionStream(locationSettings: settings).listen((
      pos,
    ) {
      gpsRequests++;

      currentPosition = pos;
      accuracy = pos.accuracy;

      distance = Geolocator.distanceBetween(
        pos.latitude,
        pos.longitude,
        target.latitude,
        target.longitude,
      );

      notifyListeners();
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
