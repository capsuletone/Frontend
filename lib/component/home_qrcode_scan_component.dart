import 'package:flutter/material.dart';

Widget homeQrcodeScanContainer(
    GestureTapCallback? onTap, double pixel, Color? bgColor, String text) {
  double widthSize = 500 * pixel;
  double heightSize = 300 * pixel;
  double fontSize = 24.0 * pixel; // 글자 크기 설정
  double spacing = 30.0 * pixel; // 두 텍스트 사이의 간격 설정

  return GestureDetector(
      onTap: onTap,
      child: Container(
        width: widthSize, // 가로 500
        height: heightSize, // 세로 300
        padding: EdgeInsets.all(16 * pixel),
        color: bgColor,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 24, // 텍스트 크기
              fontWeight: FontWeight.bold, // 텍스트 두께
              color: Colors.black, // 텍스트 색상
            ),
          ),
        ),
      ));
}
