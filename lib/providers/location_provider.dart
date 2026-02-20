import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Punto de crisis UIDE
const LatLng crisisPoint = LatLng(-4.007021, -79.204329);

class LocationState {
  final double distance;
  final double accuracy;
  final int gpsRequests;
  final bool isModelReady; // Lazy Loading logic
  final LocationAccuracy currentAccuracy;

  LocationState({
    this.distance = 999,
    this.accuracy = 999,
    this.gpsRequests = 0,
    this.isModelReady = false,
    this.currentAccuracy = LocationAccuracy.medium,
  });

  LocationState copyWith({
    double? distance,
    double? accuracy,
    int? gpsRequests,
    bool? isModelReady,
    LocationAccuracy? currentAccuracy,
  }) {
    return LocationState(
      distance: distance ?? this.distance,
      accuracy: accuracy ?? this.accuracy,
      gpsRequests: gpsRequests ?? this.gpsRequests,
      isModelReady: isModelReady ?? this.isModelReady,
      currentAccuracy: currentAccuracy ?? this.currentAccuracy,
    );
  }
}

class LocationNotifier extends StateNotifier<LocationState> {
  LocationNotifier() : super(LocationState());

  StreamSubscription<Position>? _subscription;

  void startTracking() {
    _initStream(LocationAccuracy.medium, 5);
  }

  void _initStream(LocationAccuracy acc, int filter) {
    _subscription?.cancel();
    
    _subscription = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: acc,
        distanceFilter: filter,
      ),
    ).listen((pos) {
      final d = Geolocator.distanceBetween(
        pos.latitude, pos.longitude,
        crisisPoint.latitude, crisisPoint.longitude,
      );

      state = state.copyWith(
        distance: d,
        accuracy: pos.accuracy,
        gpsRequests: state.gpsRequests + 1,
        isModelReady: d < 50, // Solo se activa a menos de 50 metros
        currentAccuracy: acc,
      );

      // Lógica de Software Verde: Ajuste dinámico de potencia
      if (d > 100 && acc != LocationAccuracy.low) {
        _initStream(LocationAccuracy.low, 20);
      } else if (d <= 100 && d > 20 && acc != LocationAccuracy.high) {
        _initStream(LocationAccuracy.high, 5);
      } else if (d <= 20 && acc != LocationAccuracy.bestForNavigation) {
        _initStream(LocationAccuracy.bestForNavigation, 1);
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final locationProvider = StateNotifierProvider<LocationNotifier, LocationState>((ref) {
  return LocationNotifier();
});