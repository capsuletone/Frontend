import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth import

const BASE_URL = "http://10.0.2.2:8080";

class ApiResponse {
  final dynamic data;
  final String? errorMessage;
  final int? statusCode;

  ApiResponse({this.data, this.errorMessage, this.statusCode});
}

Future<ApiResponse> apiCall(
  String endpoint, {
  String method = 'GET',
  dynamic body,
  Map<String, String>? params,
}) async {
  try {
    // Uri 생성 시 params 포함
    final url =
        Uri.parse('$BASE_URL/$endpoint').replace(queryParameters: params);

    // Firebase 토큰 가져오기

    // 기본 헤더에 Authorization 추가
    final headers = {'Content-Type': 'application/json; charset=UTF-8'};

    http.Response response;

    switch (method) {
      case 'GET':
        response = await http.get(url, headers: headers);
        break;
      case 'POST':
        response =
            await http.post(url, headers: headers, body: json.encode(body));
        break;
      case 'PUT':
        response =
            await http.put(url, headers: headers, body: json.encode(body));
        break;
      case 'DELETE':
        response =
            await http.delete(url, headers: headers, body: json.encode(body));
        break;
      default:
        throw ArgumentError('Invalid HTTP method $method');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse(
          data: json.decode(utf8.decode(response.bodyBytes)),
          statusCode: response.statusCode);
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      return ApiResponse(
          errorMessage: 'Error: ${response.statusCode}',
          statusCode: response.statusCode,
          data: json.decode(utf8.decode(response.bodyBytes)));
    }
  } catch (e) {
    return ApiResponse(errorMessage: 'Exception occurred: $e');
  }
}
