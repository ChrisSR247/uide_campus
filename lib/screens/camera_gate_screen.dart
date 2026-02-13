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
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text("Diagnóstico por visión"),
          backgroundColor: Colors.black,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              "Acércate al punto de intervención.\n\n"
              "Precisión actual: ${loc.accuracy.toStringAsFixed(1)} m\n\n"
              "Se requiere una precisión menor o igual a 5 metros para habilitar la cámara.",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 18),
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Cámara"),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(child: CameraPreview(_controller!)),

          const SizedBox(height: 10),

          Text(vision.label, style: const TextStyle(color: Colors.white)),

          Text(
            "Confianza: ${(vision.confidence * 100).toStringAsFixed(1)} %",
            style: const TextStyle(color: Colors.white),
          ),

          const SizedBox(height: 10),

          ElevatedButton(
            onPressed: () {
              context.read<VisionProvider>().runFakeDetection();
            },
            child: const Text("Analizar escena"),
          ),

          const SizedBox(height: 6),

          ElevatedButton(
            onPressed: vision.canIntervene
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ArInterventionScreen(),
                      ),
                    );
                  }
                : null,
            child: const Text("Intervenir (AR)"),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
