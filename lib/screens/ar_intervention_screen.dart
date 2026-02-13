import 'dart:math';
import 'package:flutter/material.dart';

class ArInterventionScreen extends StatefulWidget {
  const ArInterventionScreen({super.key});

  @override
  State<ArInterventionScreen> createState() => _ArInterventionScreenState();
}

class _ArInterventionScreenState extends State<ArInterventionScreen>
    with SingleTickerProviderStateMixin {
  bool cleaned = false;
  late AnimationController _controller;
  double uv = 0;

  @override
  void initState() {
    super.initState();

    uv = 1 + Random().nextDouble() * 10;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get uvColor {
    if (uv < 3) return const Color(0xFF00FFD1);
    if (uv < 6) return const Color(0xFFFFE600);
    if (uv < 8) return const Color(0xFFFF8A00);
    return const Color(0xFFFF3D5A);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Intervención RA"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0F1C), Color(0xFF111B2E), Color(0xFF1A2A46)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  await _controller.forward();
                  _controller.reverse();

                  setState(() {
                    cleaned = true;
                  });
                },

                child: ScaleTransition(
                  scale: Tween(begin: 1.0, end: 1.2).animate(
                    CurvedAnimation(
                      parent: _controller,
                      curve: Curves.easeInOut,
                    ),
                  ),

                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: cleaned
                            ? [Color(0xFF00FFD1), Color(0xFF00A8FF)]
                            : [Color(0xFF5F7CFF), Color(0xFF9F5FFF)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: cleaned
                              ? Color(0x5500FFD1)
                              : Color(0x559F5FFF),
                          blurRadius: 40,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      cleaned ? Icons.check : Icons.auto_fix_high,
                      color: Colors.white,
                      size: 90,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Text(
                cleaned ? "Zona estabilizada" : "Interactúa con el objeto",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 40),

              AnimatedOpacity(
                opacity: cleaned ? 1 : 0,
                duration: const Duration(milliseconds: 500),
                child: Column(
                  children: [
                    const Text(
                      "Radiación UV",
                      style: TextStyle(color: Colors.white70, letterSpacing: 2),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      width: 180,
                      height: 22,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [uvColor.withOpacity(0.4), uvColor],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: uvColor.withOpacity(0.6),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      uv.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
