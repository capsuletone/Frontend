import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:go_router/go_router.dart';

import '../database/saveuser_request_database.dart';
import '../database/saveuser_response_database.dart';
import '../utils/endpoint.dart';

class SaveuserdataRepository {
  Future<void> saveUserData(
      List<SaveUserDatabase> items, BuildContext context) async {
    final ApiResponse response =
        await apiCall('saveuserdata', method: 'POST', body: items);

    if (response.errorMessage != null) {
      print('API Error: ${response.errorMessage}');
      return;
    }

    final result = SaveUserResponseDatabase.fromJson(response.data);

    if (result.result != false) {
      print("정상적으로 사용자 수동 약 정보 저장 완료.");
      context.go('/root');
    } else {
      print("사용자 정보 저장 실패 ❌: ${result.result}");
    }
  }
}
