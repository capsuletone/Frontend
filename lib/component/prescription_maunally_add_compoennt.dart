import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Widget buildInputField(
  String label,
  TextEditingController controller,
  String hint,
  double pixel, {
  TextInputType? keyboardType,
  void Function(String)? onChanged,
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 20 * pixel),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16 * pixel,
            fontWeight: FontWeight.w600,
            fontFamily: 'Pretendard',
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8 * pixel),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: TextStyle(
            fontSize: 18 * pixel, // 입력 텍스트 크기 키우기
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 16 * pixel, // hint 텍스트 크기 키우기
              color: Colors.grey, // hint 텍스트 색상 (원하면 조절)
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8 * pixel),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12 * pixel,
              vertical: kIsWeb ? 4 * pixel : 16 * pixel,
            ),
          ),
        ),
      ],
    ),
  );
}
