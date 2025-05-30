import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ResponsiveScaler extends StatelessWidget {
  final Widget child;

  const ResponsiveScaler({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return child;

    return LayoutBuilder(builder: (context, constraints) {
      const double baseWidth = 1080;
      const double baseHeight = 2400; // 예: 아이폰 SE 기준

      double screenWidth = constraints.maxWidth;
      double screenHeight = constraints.maxHeight;

      // 비율 기준으로 가장 맞는 축을 기준으로 scale 조정
      double scaleX = screenWidth / baseWidth;
      double scaleY = screenHeight / baseHeight;
      double scale = scaleX < scaleY ? scaleX : scaleY;

      return Transform.scale(
        scale: scale,
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: baseWidth,
          height: baseHeight,
          child: child,
        ),
      );
    });
  }
}
