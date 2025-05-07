import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../database/register_database.dart';
import '../utils/endpoint.dart';

class RegisterRepository {
  Future<void> registerUser(Register registerData, BuildContext context) async {
    final ApiResponse response = await apiCall(
      'register',
      method: 'POST',
      body: registerData.toJson(),
    );

    if (response.errorMessage != null) {
      print('API Error: ${response.errorMessage}');
      return;
    }

    final decoded = utf8.decode(response.data);
    final result = jsonDecode(decoded);

    print("서버 응답 result: ${result['result']}");

    if (result['result'] == "OK") {
      print("회원가입 성공 🎉");
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("회원가입 성공"),
            content: const Text("로그인을 위해 로그인 화면으로 이동합니다."),
            actions: [
              TextButton(
                child: const Text("확인"),
                onPressed: () {
                  Navigator.pop(context);
                  context.go('/login');
                },
              ),
            ],
          );
        },
      );
    } else if (result['result'] == "이미 등록된 ID입니다") {
      print("회원가입 실패 ❌: 중복 ID");
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("회원가입 실패"),
            content: const Text("이미 등록된 ID입니다"),
            actions: [
              TextButton(
                child: const Text("확인"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    } else {
      print("회원가입 실패 ❌: ${result['result']}");
    }
  }
}
