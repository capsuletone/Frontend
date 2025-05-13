import 'package:flutter/material.dart';

class SettingBox extends StatelessWidget {
  final VoidCallback onTap;
  final String settingText;

  const SettingBox({
    super.key,
    required this.onTap,
    required this.settingText,
  });

  @override
  Widget build(BuildContext context) {
    final double pixel = MediaQuery.of(context).size.width / 375 * 0.97;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 74 * pixel,
        padding: EdgeInsets.symmetric(vertical: 20 * pixel),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Text(
              settingText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF191F28),
                fontSize: 16 * pixel,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
              ),
            )),
          ],
        ),
      ),
    );
  }
}
