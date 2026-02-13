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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Operación Campus UIDE",
          style: TextStyle(letterSpacing: 1.1),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: MapScreen.crisisPoint,
              zoom: 18,
            ),
            markers: {
              const Marker(
                markerId: MarkerId("crisis"),
                position: MapScreen.crisisPoint,
              ),
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),

          // ---- TOP OVERLAY (HUD) ----
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.65),
                      Colors.transparent,
                      Colors.black.withOpacity(0.75),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),

          // ---------- RADAR ----------
          Positioned(
            right: 18,
            bottom: 210,
            child: _Radar(
              controller: _radarController,
              distance: location.distance,
            ),
          ),

          // ---------- PANEL ----------
          const Positioned(left: 0, right: 0, bottom: 0, child: _InfoPanel()),

          // ---------- BOTÓN CÁMARA ----------
          Positioned(
            right: 18,
            bottom: 320,
            child: _NeonFab(
              enabled: true,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CameraGateScreen()),
                );
              },
              icon: Icons.camera_alt,
              label: "Visión",
            ),
          ),
        ],
      ),
    );
  }
}

class _NeonFab extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;
  final IconData icon;
  final String label;

  const _NeonFab({
    required this.enabled,
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: enabled ? onPressed : null,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF00FFD1), Color(0xFF4D8CFF)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00FFD1).withOpacity(0.35),
                  blurRadius: 22,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.camera_alt, color: Colors.black, size: 26),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

class _Radar extends StatelessWidget {
  final AnimationController controller;
  final double distance;

  const _Radar({required this.controller, required this.distance});

  Color get color {
    if (distance < 20) return const Color(0xFFFF3D5A);
    if (distance < 100) return const Color(0xFFFF8A00);
    return const Color(0xFF00FFD1);
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
        final scale = 0.55 + controller.value * 0.75;

        return Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.25),
            border: Border.all(color: Colors.white12),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Halo exterior
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.25),
                      blurRadius: 26,
                      spreadRadius: 3,
                    ),
                  ],
                ),
              ),

              // Pulso
              Transform.scale(
                scale: scale,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 3),
                  ),
                ),
              ),

              // Punto central
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.7),
                      blurRadius: 14,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ],
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

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0D1628).withOpacity(0.92),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "ESTADO DE MISIÓN",
                style: TextStyle(
                  color: Colors.white70,
                  letterSpacing: 2,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 12),

              _HudRow(
                label: "Distancia al punto",
                value: "${loc.distance.toStringAsFixed(1)} m",
              ),
              const SizedBox(height: 8),
              _HudRow(
                label: "Precisión GPS",
                value: "${loc.accuracy.toStringAsFixed(1)} m",
              ),
              const SizedBox(height: 8),
              _HudRow(label: "Peticiones GPS", value: "${loc.gpsRequests}"),

              const SizedBox(height: 14),
              Container(height: 1, color: Colors.white10),
              const SizedBox(height: 12),

              Row(
                children: [
                  const Text(
                    "Cámara habilitada",
                    style: TextStyle(color: Colors.white),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: loc.canUseCamera
                          ? const Color(0xFF00FFD1).withOpacity(0.15)
                          : const Color(0xFFFF3D5A).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: loc.canUseCamera
                            ? const Color(0xFF00FFD1).withOpacity(0.5)
                            : const Color(0xFFFF3D5A).withOpacity(0.5),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          loc.canUseCamera ? Icons.check : Icons.lock,
                          size: 18,
                          color: loc.canUseCamera
                              ? const Color(0xFF00FFD1)
                              : const Color(0xFFFF3D5A),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          loc.canUseCamera ? "LISTO" : "BLOQUEADO",
                          style: TextStyle(
                            color: loc.canUseCamera
                                ? const Color(0xFF00FFD1)
                                : const Color(0xFFFF3D5A),
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HudRow extends StatelessWidget {
  final String label;
  final String value;

  const _HudRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
