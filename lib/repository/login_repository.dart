import 'package:capsuleton_flutter/database/login_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../database/login_response_database.dart';
import '../utils/endpoint.dart';

class LoginRepository {
  Future<void> loginUser(Login loginData, BuildContext context) async {
    final ApiResponse response = await apiCall(
      'login',
      method: 'POST',
      body: loginData.toJson(),
    );

    if (response.errorMessage != null) {
      print('API Error: ${response.errorMessage}');
      return;
    }

    final result = LoginResponseDatabase.fromJson(response.data);

    if (result.result != false) {
      print("로그인 성공");
      context.go('/root');
    } else {
      print("로그인 실패 ❌: ${result.result}");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("로그인 실패"),
            content: Text("입력 정보를 확인하고 다시 시도하십시요"),
            actions: [
              TextButton(
                child: Text("확인"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
      context.go('/login');
    }
  }
}
