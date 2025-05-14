import 'dart:ui';

import 'package:flutter/material.dart';

Widget buildInputField(
    String label, TextEditingController controller, String hint, double pixel,
    {TextInputType? keyboardType, void Function(String)? onChanged}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 20 * pixel),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
              fontSize: 16 * pixel,
              fontWeight: FontWeight.w600,
              fontFamily: 'Pretendard',
              color: Colors.black,
            )),
        SizedBox(height: 8 * pixel),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12 * pixel,
              vertical: 16 * pixel,
            ),
          ),
        ),
      ],
    ),
  );
}
