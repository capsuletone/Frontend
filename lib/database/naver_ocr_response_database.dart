class NaverOcrResponseDatabase {
  final DateTime? date;
  final String? diseaseCode;
  final String? medicineName;
  final double? dosesPerDay;
  final String? totalDays;

  NaverOcrResponseDatabase({
    this.date,
    this.diseaseCode,
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
      dosesPerDay: json['totalDays'],

      // 'totalDays'가 null이면 빈 문자열, 아니면 값 그대로
      totalDays: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'date'가 null일 경우 빈 문자열로 처리하거나, DateTime 형식을 맞춰서 처리
      'date': date?.toIso8601String(),

      // 'diseaseCode', 'medicineName', 'totalDays'는 기본값을 빈 문자열로 설정
      'diseaseCode': diseaseCode,
      'medicineName': medicineName,

      // 'dosesPerDay'가 null이면 0으로 처리
      'dosesPerDay': dosesPerDay,

      // 'totalDays'는 기본값을 빈 문자열로 설정
      'totaldays': totalDays,
    };
  }
}
