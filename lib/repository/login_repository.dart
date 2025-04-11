import 'package:capsuleton_flutter/database/login_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../database/login_response_database.dart';
import '../utils/endpoint.dart';

class LoginRepository {
  Future<void> loginUser(Login loginData, BuildContext context) async {
    final ApiResponse response = await apiCall(
      'login', // 예시 엔드포인트
      method: 'POST',
      body: loginData.toJson(),
    );

    if (response.errorMessage != null) {
      print('API Error: ${response.errorMessage}');
      return;
    }

    final result = LoginResponseDatabase.fromJson(response.data);

    if (result.result != false) {
      print("회원가입 성공 🎉");
      context.go('/home');
    } else {
      print("회원가입 실패 ❌: ${result.result}");
      context.go('/root');
    }
  }
}
