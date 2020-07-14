import 'dart:math';
import 'dart:ui';
import 'package:dart_numerics/dart_numerics.dart' as numerics;
import 'package:flutter/material.dart';

class RandomColor {
  static Random _random = Random();
  static Color Get() {
    return Color(_random.nextInt(4294967296));
  }

  static Color GlabalColor = Colors.purple;
}
