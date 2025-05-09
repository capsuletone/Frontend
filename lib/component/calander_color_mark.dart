import 'package:flutter/material.dart';

Color getColorByIndex(int index) {
  final List<Color> colorPalette = [
    Colors.green[500]!,
    Colors.green[400]!,
    Colors.green[300]!,
    Colors.green[200]!,
    Colors.green[100]!,
  ];
  return colorPalette[index % colorPalette.length];
}
