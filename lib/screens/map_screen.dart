import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../providers/location_provider.dart';
import 'camera_gate_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  static const LatLng crisisPoint = LatLng(-4.007021, -79.204329);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _radarController;

  @override
  void initState() {
    super.initState();

    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    Future.microtask(() {
      context.read<LocationProvider>().startTracking();
    });
  }

  @override
  void dispose() {
    _radarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final location = context.watch<LocationProvider>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Operación Campus UIDE"),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: MapScreen.crisisPoint,
              zoom: 18,
            ),
            markers: {
              Marker(
                markerId: MarkerId("crisis"),
                position: MapScreen.crisisPoint,
              ),
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),

          // ---------- RADAR ----------
          Positioned(
            right: 20,
            bottom: 140,
            child: _Radar(
              controller: _radarController,
              distance: location.distance,
            ),
          ),

          // ---------- PANEL ----------
          const Positioned(left: 0, right: 0, bottom: 0, child: _InfoPanel()),

          // ---------- BOTÓN CÁMARA ----------
          Positioned(
            right: 20,
            bottom: 260,
            child: FloatingActionButton(
              backgroundColor: Colors.greenAccent,
              child: const Icon(Icons.camera_alt, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CameraGateScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Radar extends StatelessWidget {
  final AnimationController controller;
  final double distance;

  const _Radar({required this.controller, required this.distance});

  Color get color {
    if (distance < 20) return Colors.redAccent;
    if (distance < 100) return Colors.orange;
    return Colors.greenAccent;
  }

  double get speed {
    if (distance < 20) return 0.8;
    if (distance < 100) return 1.5;
    return 2.5;
  }

  @override
  Widget build(BuildContext context) {
    controller.duration = Duration(milliseconds: (speed * 1000).toInt());

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final scale = 0.6 + controller.value * 0.6;

        return Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.25),
          ),
          child: Transform.scale(
            scale: scale,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 3),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel();

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<LocationProvider>();

    return Container(
      padding: const EdgeInsets.all(14),
      color: Colors.black.withOpacity(0.85),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Distancia al punto: ${loc.distance.toStringAsFixed(1)} m",
              style: const TextStyle(color: Colors.white),
            ),

            Text(
              "Precisión GPS: ${loc.accuracy.toStringAsFixed(1)} m",
              style: const TextStyle(color: Colors.white),
            ),

            Text(
              "Peticiones GPS: ${loc.gpsRequests}",
              style: const TextStyle(color: Colors.white),
            ),

            const SizedBox(height: 6),

            Row(
              children: [
                const Text(
                  "Cámara habilitada: ",
                  style: TextStyle(color: Colors.white),
                ),
                Icon(
                  loc.canUseCamera ? Icons.check_circle : Icons.cancel,
                  color: loc.canUseCamera
                      ? Colors.greenAccent
                      : Colors.redAccent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
