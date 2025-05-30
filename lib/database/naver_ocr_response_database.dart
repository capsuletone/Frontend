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
  List<dynamic> parseList(dynamic value) {
    if (value is List) return value;
    if (value == null) return [];
    return [value]; // 단일 값일 경우 리스트로 변환
  }

  return NaverOcrResponseDatabase(
    date: json['date']?.toString(),
    diseaseCode: json['diseaseCode']?.toString(),
    medicineName: parseList(json['medicineName']),
    dosesPerDay: parseList(json['dosesPerDay']),
    totalDays: parseList(json['totalDays']),
  );
}

}
