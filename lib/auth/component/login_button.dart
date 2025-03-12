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
    final pixel = MediaQuery.of(context).size.width / 393 * 0.97;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 298 * pixel,
        height: 25 * pixel,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: child ??
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
        ),
      ),
    );
  }
}
