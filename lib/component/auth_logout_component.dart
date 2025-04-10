import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AccountLogout extends StatefulWidget {
  @override
  State<AccountLogout> createState() => _AccountLogoutState();
}

class _AccountLogoutState extends State<AccountLogout> {
  @override
  Widget build(BuildContext context) {
    final pixel = MediaQuery.of(context).size.width / 393 * 0.97;
    return Container(
      width: 345 * pixel,
      height: 193 * pixel,
      padding: EdgeInsets.symmetric(
        vertical: 30 * pixel,
        horizontal: 22 * pixel,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12 * pixel),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              child: Column(children: [
            Text(
              '로그아웃',
              style: TextStyle(
                color: Color(0xFF191F28),
                fontSize: 18 * pixel,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            SizedBox(
              height: 12 * pixel,
            ),
            Text(
              '로그아웃을 하시겠습니까?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15 * pixel,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
              ),
            ),
          ])),
          Container(
            width: 297 * pixel,
            height: 50 * pixel,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // 자식 간 공간 균등 분배
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 135 * pixel,
                    height: 50 * pixel,
                    decoration: ShapeDecoration(
                      color: Color(0x7F191F28),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12 * pixel),
                      ),
                    ),
                    child: Center(
                      // Column 대신 Center로 간소화
                      child: Text(
                        '취소',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14 * pixel,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 11 * pixel,
                ),
                GestureDetector(
                  onTap: () async {
                    if (mounted) {
                      context.go('/login');
                      print("로그아웃 성공");
                    } else {
                      print("로그아웃 실패");
                    }
                  },
                  child: Container(
                    width: 135 * pixel,
                    height: 50 * pixel,
                    decoration: ShapeDecoration(
                      color: Colors.green[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12 * pixel),
                      ),
                    ),
                    child: Center(
                      // Column 대신 Center로 간소화
                      child: Text(
                        '로그아웃',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14 * pixel,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
