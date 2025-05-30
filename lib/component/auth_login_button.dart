import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final Widget? child;

  const LoginButton({
    super.key,
    required this.onTap,
    required this.text,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final pixel = MediaQuery.of(context).size.width / 375 * 0.97;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 340 * pixel,
        height: 50 * pixel,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(10 * pixel), // 여기에 직접 사용합니다!
        ),
        child: Center(
          child: child ??
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16 * pixel,
                ),
              ),
        ),
      ),
    );
  }
}
