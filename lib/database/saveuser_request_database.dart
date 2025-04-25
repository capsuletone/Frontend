class SaveUserDatabase {
  final String? userid;
  final String? diseaseCode;
  final String? medicineName;
  final String? time;
  final int? totalDays;
  final String? date;

  SaveUserDatabase({
    this.userid,
    this.diseaseCode,
    this.medicineName,
    this.time,
    this.totalDays,
    this.date,
  });

  factory SaveUserDatabase.fromJson(Map<String, dynamic> json) {
    return SaveUserDatabase(
      userid: json['userid'],
      diseaseCode: json['diseaseCode'],
      medicineName: json['medicineName'],
      time: json['time'],
      totalDays: json['totalDays'],
      date: json['date'],
    );
  }

  // toJson 메소드
  Map<String, dynamic> toJson() {
    return {
      'userid': userid,
      'diseaseCode': diseaseCode,
      'medicineName': medicineName,
      'time': time,
      'totalDays': totalDays,
      'date': date,
    };
  }
}
