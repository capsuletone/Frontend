class NaverOcrRequestDatabase {
  String? base64img;

  NaverOcrRequestDatabase({required this.base64img});

  factory NaverOcrRequestDatabase.fromJson(Map<String, dynamic> json) {
    return NaverOcrRequestDatabase(
      base64img: json['base64img'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'base64img': base64img,
    };
  }
}
