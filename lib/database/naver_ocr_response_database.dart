class NaverOcrResponseDatabase {
  String? date;
  String? diseaseCode;
  List<String?> medicineName;
  List<double?> dosesPerDay;
  List<int?> totalDays;

  NaverOcrResponseDatabase(
      {required this.date,
      required this.diseaseCode,
      required this.medicineName,
      required this.dosesPerDay,
      required this.totalDays});

  factory NaverOcrResponseDatabase.fromJson(Map<String, dynamic> json) {
    return NaverOcrResponseDatabase(
      date: json['date'],
      diseaseCode: json['diseaseCode'],
      medicineName: json['medicineName'],
      dosesPerDay: json['totalDays'],
      totalDays: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'diseaseCode': diseaseCode,
      'medicineName': medicineName,
      'dosesPerDay': dosesPerDay,
      'totaldays': totalDays,
    };
  }
}
