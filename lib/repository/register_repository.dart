import 'package:capsuleton_flutter/database/register_response_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../database/register_database.dart';
import '../utils/endpoint.dart';

class RegisterRepository {
  Future<void> registerUser(
      Register registerData, BuildContext context, double pixel) async {
    try {
      final ApiResponse response = await apiCall(
        'register',
        method: 'POST',
        body: registerData.toJson(),
      );

      if (response.errorMessage != null) {
        print('API Error: ${response.errorMessage}');
      }

      final result = RegisterResponseDatabase.fromJson(response.data);
      print("서버 응답 result: ${result.result}");

      if (result.result == "alreadyexist") {
        print("회원가입 실패 ❌: 중복 ID");
        if (!context.mounted) return;

        return showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text("회원가입 실패"),
              content: const Text("이미 등록된 ID입니다."),
              actions: [
                TextButton(
                  child: const Text("확인"),
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                ),
              ],
            );
          },
        );
      } else if (result.result == "true") {
        print("회원가입 성공 🎉");
        if (!context.mounted) return; // context 유효성 확인

        return showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text("회원가입 성공"),
              content: const Text("로그인을 위해 로그인 화면으로 이동합니다."),
              actions: [
                TextButton(
                  child: const Text("확인"),
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    context.go('/login');
                  },
                ),
              ],
            );
          },
        );
      } else {
        print("회원가입 실패 ❌: 알 수 없는 오류");
        if (!context.mounted) return;

        return showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text(
                "회원가입 실패",
                style: TextStyle(fontSize: 16 * pixel),
              ),
              content: Text(
                "알 수 없는 오류가 발생했습니다.",
                style: TextStyle(fontSize: 16 * pixel),
              ),
              actions: [
                TextButton(
                  child: Text(
                    "확인",
                    style: TextStyle(fontSize: 14 * pixel),
                  ),
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print("예외 발생 ❗: $e");
      if (!context.mounted) return;

      return showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text(
                '에러 발생',
                style: TextStyle(fontSize: 16 * pixel),
              ),
              content: Text(
                '알 수 없는 오류가 발생했습니다.',
                style: TextStyle(fontSize: 16 * pixel),
              ),
              actions: [
                TextButton(
                  child: Text(
                    '닫기',
                    style: TextStyle(fontSize: 14 * pixel),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          });
    }
  }
}
