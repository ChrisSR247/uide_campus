import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart';
import '../providers/vision_provider.dart';
import 'ar_intervention_screen.dart';
import 'package:camera/camera.dart';

class CameraGateScreen extends StatelessWidget {
  const CameraGateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<LocationProvider>();

    if (!loc.canUseCamera) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text("Diagnóstico por visión"),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF050B18), Color(0xFF0F1C33), Color(0xFF1C2F52)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24),
                ),
                child: Text(
                  "Acércate al punto de intervención.\n\n"
                  "Precisión actual: ${loc.accuracy.toStringAsFixed(1)} m\n\n"
                  "Se requiere una precisión menor o igual a 5 metros para habilitar la cámara.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return const _FakeCameraScreen();
  }
}

class _FakeCameraScreen extends StatefulWidget {
  const _FakeCameraScreen();

  @override
  State<_FakeCameraScreen> createState() => _FakeCameraScreenState();
}

class _FakeCameraScreenState extends State<_FakeCameraScreen> {
  CameraController? _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    _controller = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller!.initialize();

    setState(() {
      _loading = false;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vision = context.watch<VisionProvider>();

    if (_loading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Cámara"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          /// CAMARA
          Positioned.fill(child: CameraPreview(_controller!)),

          /// OVERLAY
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          /// PANEL INFERIOR
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1628).withOpacity(0.9),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// LABEL
                  Text(
                    vision.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// CONFIDENCE BAR
                  Container(
                    height: 8,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white12,
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: vision.confidence,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00FFD1), Color(0xFF4D8CFF)],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Confianza ${(vision.confidence * 100).toStringAsFixed(1)} %",
                    style: const TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 18),

                  /// BOTONES
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<VisionProvider>().runFakeDetection();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5F7CFF),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text("Analizar"),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: ElevatedButton(
                          onPressed: vision.canIntervene
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const ArInterventionScreen(),
                                    ),
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00FFD1),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text("Intervenir"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
