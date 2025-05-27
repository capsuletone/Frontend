import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const LoginTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    final pixel = MediaQuery.of(context).size.width / 375 * 0.97;
    return Container(
      width: 340 * pixel,
      height: 50 * pixel,
      padding:
          EdgeInsets.symmetric(horizontal: 16 * pixel, vertical: 8 * pixel),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14 * pixel), // 여기에 직접 사용합니다!
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(
          fontSize: 20.0 * pixel, // 텍스트 크기를 여기서 설정
          color: Colors.black, // 텍스트 색상도 필요하면 설정 가능
        ),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          fillColor: Colors.transparent,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14 * pixel, color: Colors.grey[600]),
        ),
      ),
    );
  }
}
