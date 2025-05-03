import 'requestuser_response_database.dart';

class RequestuserResponseExtentionsDatabase {
  final String? diseaseCode;
  final List<Medicine>? medicines;

  RequestuserResponseExtentionsDatabase({
    this.diseaseCode,
    this.medicines,
  });
  factory RequestuserResponseExtentionsDatabase.fromJson(
      Map<String, dynamic> json) {
    var meds = json['medicines'] as List?;

    List<Medicine>? medicineList;
    try {
      medicineList = meds?.map((e) {
        if (e is Map<String, dynamic>) {
          return Medicine.fromJson(e); // 정상적인 Map이면 그대로 처리
        } else if (e is List) {
          // List 형태일 경우
          return Medicine.fromJson({
            'medicineName': e[0], // e[0]은 약 이름
            'time': e[1], // e[1]은 복용 시간
            'totalDays': e[2], // e[2]는 총 복용 일수
            'date': e[3], // e[3]은 복용 시작 날짜
          });
        } else {
          // 그 외의 경우에는 에러 처리
          throw FormatException('Invalid medicine data format');
        }
      }).toList();
    } catch (e) {
      print("medicine 변환 실패: $e");
      medicineList = [];
    }

    return RequestuserResponseExtentionsDatabase(
      diseaseCode: json['diseaseCode'],
      medicines: medicineList,
    );
  }
}
