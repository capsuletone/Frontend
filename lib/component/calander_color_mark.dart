import 'package:flutter/material.dart';

Color getColorByIndex(int index) {
  switch (index) {
    case 0:
      return Colors.green;
    case 1:
      return Colors.blue;
    case 2:
      return Colors.orange;
    case 3:
      return Colors.red;
    default:
      return Colors.grey;
  }
}
