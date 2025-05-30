import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/requestuser_request_database.dart';
import '../database/requestuser_response_extentions_database.dart';
import '../provider/user_data_provider.dart';
import '../utils/endpoint.dart';

class RequestuserRepository {
  Future<List<RequestuserResponseExtentionsDatabase>?> requestUser(
      RequestuserRequestDatabase requestUserData, BuildContext context) async {
    final ApiResponse response = await apiCall(
      'requestuserdata',
      method: 'POST',
      body: requestUserData.toJson(),
    );

    if (response.errorMessage != null) {
      print('API Error: ${response.errorMessage}');
      return null;
    }

    try {
      final List<dynamic> jsonList = response.data as List;
      final resultList = jsonList
          .map((e) => RequestuserResponseExtentionsDatabase.fromJson(e))
          .toList();
      Provider.of<UserDiseaseProvider>(context, listen: false)
          .setDiseaseData(resultList);
      for (var item in resultList) {
        print('질병 코드: ${item.diseaseCode}');
        for (var med in item.medicines ?? []) {
          print('💊 ${med.medicineName} / ${med.time} / ${med.totalDays}일');
        }
      }

      return resultList;
    } catch (e) {
      print('응답 파싱 실패 ❌: $e');
      return null;
    }
  }
}
