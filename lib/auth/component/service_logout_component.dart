import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ServiceLogout extends StatefulWidget {
  @override
  State<ServiceLogout> createState() => _ServiceLogoutState();
}

class _ServiceLogoutState extends State<ServiceLogout> {
  @override
  Widget build(BuildContext context) {
    final pixel = MediaQuery.of(context).size.width / 375 * 0.97;
    Future<void> deleteUserAccount() async {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.delete();
        print('User 정보가 성공적으로 삭제되었습니다.');
      }
    }

    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
          child: Container(
        width: 345 * pixel,
        height: 270 * pixel,
        padding:
            EdgeInsets.symmetric(vertical: 25 * pixel, horizontal: 24 * pixel),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12 * pixel),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('회원탈퇴',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF191F28),
                  fontSize: 18 * pixel,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                )),
            SizedBox(
              height: 12 * pixel,
            ),
            Text('탈퇴 시 회원님의 모든 정보가 삭제됩니다.\n그래도 탈퇴하시겠어요?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14 * pixel,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                )),
            SizedBox(
              height: 20 * pixel,
            ),
            Container(
              width: 297 * pixel,
              height: 50 * pixel,
              decoration: ShapeDecoration(
                color: Colors.green[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12 * pixel),
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(); // 팝업 닫기
                },
                child: Center(
                  child: Text(
                    '다시 생각해보기',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15 * pixel,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40 * pixel,
            ),
            GestureDetector(
                onTap: () async {
                  deleteUserAccount();
                  context.go('/login');
                },
                child: Text(
                  '회원 탈퇴하기',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14 * pixel,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                  ),
                )),
          ],
        ),
      ));
    });
  }
}
