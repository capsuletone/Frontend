import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import '../database/tablet_database.dart';

class TabletRepository {
  // api key
  var apiKey =
      "T%2Fqjm8YMt7MX66%2FjhEmvxE3uUZhLj6lNixjCFWZdIfak234VgAuMYjV1jnt25rIzpRF2ywP%2BvPpUdfLTLseNNQ%3D%3D";

  Future<Tablet?> loadTablet(String itemName) async {
    String baseUrl =
        "https://apis.data.go.kr/1471000/DrbEasyDrugInfoService/getDrbEasyDrugList?serviceKey=$apiKey&itemName=$itemName"; // 실제 API URL로 변경하세요.

    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final body = convert.utf8.decode(response.bodyBytes);

      // XML → JSON 변환
      final xml = Xml2Json()..parse(body);
      final json = xml.toParker();

      // JSON 파싱
      Map<String, dynamic> jsonResult = convert.json.decode(json);
      final jsonEv = jsonResult['response']['body']['items'];

      if (jsonEv['item'] != null) {
        dynamic itemData = jsonEv['item'];

        if (itemData is List) {
          // 리스트일 경우, 첫 번째 항목만 가져오기

          return Tablet.fromJson(itemData.first);
        } else {
          // 단일 객체일 경우
          return Tablet.fromJson(itemData);
        }
      }
    }

    return null; // 데이터를 찾을 수 없는 경우 null 반환
  }
}
