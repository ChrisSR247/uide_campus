import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../providers/location_provider.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> with SingleTickerProviderStateMixin {
  late AnimationController _radarController;

  @override
  void initState() {
    super.initState();
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    Future.microtask(() => ref.read(locationProvider.notifier).startTracking());
  }

  @override
  void dispose() {
    _radarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = ref.watch(locationProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("OPERACIÓN UIDE", style: TextStyle(letterSpacing: 1.2)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(target: crisisPoint, zoom: 18),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            markers: {
              const Marker(markerId: MarkerId("crisis"), position: crisisPoint),
            },
          ),
          
          // HUD Overlays
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.6), Colors.transparent, Colors.black.withOpacity(0.7)],
                    begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),

          // RADAR
          Positioned(
            right: 18, bottom: 210,
            child: _Radar(controller: _radarController, distance: loc.distance),
          ),

          // PANEL INFERIOR
          Positioned(left: 0, right: 0, bottom: 0, child: _InfoPanel(loc: loc)),

          // BOTÓN VISIÓN
          Positioned(
            right: 18, bottom: 320,
            child: _NeonFab(
              enabled: loc.distance < 20, // Solo habilitado si está muy cerca
              onPressed: () => print("Navegando a visión..."),
              icon: Icons.camera_alt,
              label: "VISIÓN",
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  final LocationState loc;
  const _InfoPanel({required this.loc});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1628).withOpacity(0.9),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _HudRow(label: "DISTANCIA", value: "${loc.distance.toStringAsFixed(1)} m"),
            const SizedBox(height: 8),
            _HudRow(label: "PRECISIÓN", value: "${loc.accuracy.toStringAsFixed(1)} m"),
            const SizedBox(height: 8),
            _HudRow(label: "PETICIONES GPS", value: "${loc.gpsRequests}"),
            const Divider(color: Colors.white10, height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("ESTADO 3D:"),
                Text(
                  loc.isModelReady ? "DESCARGADO" : "EN ESPERA (Lazy Loading)",
                  style: TextStyle(color: loc.isModelReady ? const Color(0xFF00FFD1) : Colors.orange),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HudRow extends StatelessWidget {
  final String label, value;
  const _HudRow({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _Radar extends StatelessWidget {
  final AnimationController controller;
  final double distance;
  const _Radar({required this.controller, required this.distance});

  @override
  Widget build(BuildContext context) {
    Color radarColor = distance < 50 ? Colors.redAccent : const Color(0xFF00FFD1);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: radarColor.withOpacity(1 - controller.value)),
          ),
          child: Center(
            child: Container(
              width: 10, height: 10,
              decoration: BoxDecoration(color: radarColor, shape: BoxShape.circle),
            ),
          ),
        );
      },
    );
  }
}

class _NeonFab extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;
  final IconData icon;
  final String label;

  const _NeonFab({required this.enabled, required this.onPressed, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: Column(
        children: [
          FloatingActionButton(
            onPressed: enabled ? onPressed : null,
            backgroundColor: const Color(0xFF00FFD1),
            child: Icon(icon, color: Colors.black),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}