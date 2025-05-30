import 'package:flutter/material.dart';

import '../database/requestuser_response_extentions_database.dart';

class UserDiseaseProvider with ChangeNotifier {
  List<RequestuserResponseExtentionsDatabase> _diseaseData = [];

  List<RequestuserResponseExtentionsDatabase> get diseaseData => _diseaseData;

  void setDiseaseData(List<RequestuserResponseExtentionsDatabase> data) {
    _diseaseData = data;
    notifyListeners(); // 💡 데이터를 설정한 후 UI에 반영되도록 알림
  }

  void clearData() {
    _diseaseData = [];
    notifyListeners(); // 💡 데이터 초기화 후 UI 갱신
  }
}
