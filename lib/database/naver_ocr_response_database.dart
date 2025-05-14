class NaverOcrResponseDatabase {
  final String? date;
  final String? diseaseCode;
  final List<dynamic> medicineName;
  final List<dynamic> dosesPerDay;
  final List<dynamic> totalDays;

  NaverOcrResponseDatabase({
    required this.date,
    required this.diseaseCode,
    required this.medicineName,
    required this.dosesPerDay,
    required this.totalDays,
  });

  factory NaverOcrResponseDatabase.fromJson(Map<String, dynamic> json) {
    return NaverOcrResponseDatabase(
      // 'date'가 null이 아니면 DateTime으로 변환, null이면 null
      date: json['date'],

      // 'diseaseCode'가 null이면 빈 문자열, 아니면 값 그대로
      diseaseCode: json['diseaseCode'],

      // 'medicineName'이 null이면 빈 문자열, 아니면 값 그대로
      medicineName: json['medicineName'],

      // 'dosesPerDay'가 null이면 0, 아니면 값 그대로
      dosesPerDay: json['dosesPerDay'],

      // 'totalDays'가 null이면 빈 문자열, 아니면 값 그대로
      totalDays: json['totalDays'],
    );
  }
}
