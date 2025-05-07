import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'auth_logout_component.dart';

Widget homeheader(double pixel, BuildContext context, String email) {
  double fontSize = 24.0 * pixel; // 글자 크기 설정
  double spacing = 10.0 * pixel; // 두 텍스트 사이의 간격 설정

  return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Row(children: [
      Text(
        '${email}님 ,',
        style: TextStyle(fontSize: fontSize),
      ),
      SizedBox(width: spacing), // 'hi'와 'hello' 사이 간격
      Text(
        '안녕하세요',
        style: TextStyle(fontSize: fontSize),
      ),
    ]),
    GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20 * pixel),
                ),
                child: AccountLogout(),
              );
            },
          );
        },
        child: FaIcon(
          FontAwesomeIcons.signOutAlt,
          color: Colors.black,
          size: 20 * pixel,
        )),
  ]);
}
