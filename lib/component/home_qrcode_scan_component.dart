import 'package:flutter/material.dart';

Widget homeQrcodeScanContainer(
    GestureTapCallback? onTap, double pixel, Color? bgColor, String text) {
  double fontSize = 22.0 * pixel;

  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity, // 화면 너비를 꽉 채움
      height: 240 * pixel, // 충분한 높이
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [bgColor ?? Colors.green.shade600, Colors.green.shade200],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20 * pixel),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12 * pixel,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: 25 * pixel, vertical: 40 * pixel),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 22 * pixel,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
