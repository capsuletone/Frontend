import 'package:capsuleton_flutter/database/register_database.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import '../database/register_response_database.dart';
import '../utils/endpoint.dart';
import 'package:go_router/go_router.dart';

class RegisterRepository {
  Future<void> registerUser(Register registerData, BuildContext context) async {
    final ApiResponse response = await apiCall(
      'register',
      method: 'POST',
      body: registerData.toJson(),
    );

    if (response.errorMessage != null) {
      print('API Error: ${response.errorMessage}');
      // 여기에 실패 처리 로직 (예: 사용자에게 알림)
      return;
    }

    final result = RegisterResponseDatabase.fromJson(response.data);

    if (result.result == "OK") {
      print("회원가입 성공 🎉");
      context.go('/login');
    } else {
      print("회원가입 실패 ❌: ${result.result}");
    }
  }
}
