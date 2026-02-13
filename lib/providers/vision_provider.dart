import 'dart:math';
import 'package:flutter/material.dart';

class VisionProvider extends ChangeNotifier {
  double confidence = 0.0;
  String label = "Sin detección";

  bool get canIntervene => confidence >= 0.80;

  void runFakeDetection() {
    final rnd = Random();

    confidence = rnd.nextDouble();
    label = confidence > 0.8 ? "Botella detectada" : "No se reconoce residuo";

    notifyListeners();
  }
}
