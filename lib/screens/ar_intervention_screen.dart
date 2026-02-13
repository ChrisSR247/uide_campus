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
    if (uv < 3) return Colors.greenAccent;
    if (uv < 6) return Colors.yellowAccent;
    if (uv < 8) return Colors.orangeAccent;
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Intervención RA"),
        backgroundColor: Colors.black,
      ),
      body: Center(
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
                  CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
                ),
                child: Icon(
                  cleaned ? Icons.check_circle : Icons.cleaning_services,
                  color: cleaned ? Colors.greenAccent : Colors.cyanAccent,
                  size: 140,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              cleaned
                  ? "Foco de contaminación sanado"
                  : "Toca el objeto para intervenir",
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),

            const SizedBox(height: 30),

            AnimatedOpacity(
              opacity: cleaned ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              child: Column(
                children: [
                  const Text(
                    "Índice UV simulado",
                    style: TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    width: 140,
                    height: 20,
                    decoration: BoxDecoration(
                      color: uvColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    uv.toStringAsFixed(1),
                    style: const TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
