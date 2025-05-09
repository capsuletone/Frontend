import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'auth_logout_component.dart';

Widget homeHeader(double pixel, BuildContext context, String email) {
  double fontSize = 24.0 * pixel;
  double iconSize = 24.0 * pixel;
  double spacing = 8.0 * pixel;

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Text(
            '$email님,',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(width: spacing),
          Text(
            '안녕하세요!',
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.black54,
            ),
          ),
        ],
      ),
      GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20 * pixel),
                ),
                child: const AccountLogout(),
              );
            },
          );
        },
        child: MouseRegion(
          // 웹 지원 시 마우스 커서
          cursor: SystemMouseCursors.click,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
            ),
            child: FaIcon(
              FontAwesomeIcons.signOutAlt,
              color: Colors.black,
              size: iconSize,
            ),
          ),
        ),
      ),
    ],
  );
}
