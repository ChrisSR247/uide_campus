import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:uide_campus_cleaner/providers/vision_provider.dart';

import 'providers/location_provider.dart';
import 'screens/map_screen.dart';
import 'screens/permission_error_screen.dart';
import 'providers/vision_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => VisionProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const PermissionGate(),
    );
  }
}

class PermissionGate extends StatefulWidget {
  const PermissionGate({super.key});

  @override
  State<PermissionGate> createState() => _PermissionGateState();
}

class _PermissionGateState extends State<PermissionGate> {
  bool loading = true;
  bool granted = false;
  String error = "";

  @override
  void initState() {
    super.initState();
    checkPermissions();
  }

  Future<void> checkPermissions() async {
    final location = await Permission.locationWhenInUse.request();
    final camera = await Permission.camera.request();

    if (location.isGranted && camera.isGranted) {
      granted = true;
    } else {
      error =
          "Esta aplicación necesita acceso a ubicación y cámara para detectar focos de contaminación y realizar la intervención en realidad aumentada.";
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!granted) {
      return PermissionErrorScreen(message: error);
    }

    return const MapScreen();
  }
}
