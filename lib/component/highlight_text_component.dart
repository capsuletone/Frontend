import 'package:flutter/material.dart';

Widget highlightText(double pixel, BuildContext context, String text) {
  double fontSize = 24.0 * pixel; // 글자 크기 설정
  double spacing = 10.0 * pixel; // 두 텍스트 사이의 간격 설정

  return Container(
    height: 40.0 * pixel,
    child: Row(
      children: [
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.black,
              fontSize: 25 * pixel,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}
