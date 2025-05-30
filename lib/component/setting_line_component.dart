import 'package:flutter/material.dart';

Widget settingLine(double pixel) {
  return Container(
      width: 354 * pixel,
      decoration: const ShapeDecoration(
        color: Color(0x33191F28), // 20% 불투명도

        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: Color(0x33191F28),
          ),
        ),
      ));
}
