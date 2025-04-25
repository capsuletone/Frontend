class Medicine {
  final String medicineName;
  final String time;
  final int totalDays;
  final DateTime date;

  Medicine(
      {required this.medicineName,
      required this.time,
      required this.totalDays,
      required this.date});

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      medicineName: json['medicineName'],
      time: json['time'],
      totalDays: json['totalDays'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicineName': medicineName,
      'time': time,
      'totaldays': totalDays,
      'date': date,
    };
  }
}
