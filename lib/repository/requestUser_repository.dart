import 'package:flutter/material.dart';
import '../database/requestuser_request_database.dart';

import '../utils/endpoint.dart';

class RequestuserRepository {
  Future<void> requestUser(
      RequestuserRequestDatabase requestUserData, BuildContext context) async {
    final ApiResponse response = await apiCall(
      'requestuserdata',
      method: 'POST',
      body: requestUserData.toJson(),
    );

    if (response.errorMessage != null) {
      print('API Error: ${response.errorMessage}');
      return;
    }

    print('${response.data}');
  }
}
