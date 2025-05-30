class NaverOcrRequestDatabase {
  String? base64;

  NaverOcrRequestDatabase({required this.base64});

  factory NaverOcrRequestDatabase.fromJson(Map<String, dynamic> json) {
    return NaverOcrRequestDatabase(
      base64: json['base64'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'base64': base64,
    };
  }
}
