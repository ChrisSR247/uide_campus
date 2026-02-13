import 'package:flutter/material.dart';

class PermissionErrorScreen extends StatelessWidget {
  final String message;

  const PermissionErrorScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF070B14), Color(0xFF141C2E), Color(0xFF1C243A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A).withOpacity(0.9),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFFFF3D5A).withOpacity(0.6),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF3D5A).withOpacity(0.25),
                    blurRadius: 30,
                    spreadRadius: 4,
                  ),
                ],
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// ICONO CON HALO
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFF3D5A).withOpacity(0.15),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF3D5A).withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xFFFF3D5A),
                      size: 52,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "ACCESO RESTRINGIDO",
                    style: TextStyle(
                      color: Colors.white70,
                      letterSpacing: 2,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
