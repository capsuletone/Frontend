import 'package:capsuleton_flutter/database/naver_ocr_request_database.dart';
import 'package:capsuleton_flutter/database/naver_ocr_response_database.dart';
import 'package:flutter/material.dart';

import '../screens/scan_result_screen.dart';
import '../utils/endpoint.dart';

class NaverOcrRepository {
  Future<void> ocrPicture(NaverOcrRequestDatabase ocrData, BuildContext context,
      double pixel) async {
    try {
      final ApiResponse response = await apiCall(
        'Naverocr',
        method: 'POST',
        body: ocrData.toJson(),
      );

      Navigator.of(context, rootNavigator: true).pop();

      if (response.errorMessage != null) {
        print('API Error: ${response.errorMessage}');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('오류'),
            content: Text('OCR 처리 중 문제가 발생했습니다. 다시 시도해주세요.'),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
        return;
      }
      final result = NaverOcrResponseDatabase.fromJson(response.data);

      print("Date: ${result.date}");
      print("Disease Code: ${result.diseaseCode}");
      print("Medicine Name: ${result.medicineName}");
      print("Doses Per Day: ${result.dosesPerDay}");
      print("Total Days: ${result.totalDays}");

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OcrresultPage(result: result),
        ),
      );
    } catch (e) {
      print("예외 발생: $e");

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
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
        ),
      );
    }
  }
}
