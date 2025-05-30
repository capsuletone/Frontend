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
          return Medicine.fromJson(e);
        }
        return Medicine.fromJson({
          'medicineName': e[0],
          'time': e[1],
          'totalDays': e[2],
          'date': e[3],
        });
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
