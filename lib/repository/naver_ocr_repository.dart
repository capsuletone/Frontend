import 'package:capsuleton_flutter/database/naver_ocr_request_database.dart';
import 'package:capsuleton_flutter/database/naver_ocr_response_database.dart';
import 'package:flutter/material.dart';

import '../utils/endpoint.dart';

class NaverOcrRepository {
  Future<void> ocrPicture(
      NaverOcrRequestDatabase ocrData, BuildContext context) async {
    final ApiResponse response = await apiCall(
      'Naverocr',
      method: 'POST',
      body: ocrData.toJson(),
    );

    if (response.errorMessage != null) {
      print('API Error: ${response.errorMessage}');
      // 여기에 실패 처리 로직 (예: 사용자에게 알림)
      return;
    }

    final result = NaverOcrResponseDatabase.fromJson(response.data);

    print("ocr 데이터 : $result");
  }
}
