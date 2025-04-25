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
    List<Medicine>? medicineList =
        meds?.map((e) => Medicine.fromJson(e)).toList();

    return RequestuserResponseExtentionsDatabase(
      diseaseCode: json['diseaseCode'],
      medicines: medicineList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'diseaseCode': diseaseCode,
      'medicines': medicines?.map((e) => e.toJson()).toList(),
    };
  }
}
