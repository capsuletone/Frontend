class RegisterResponseDatabase {
  String? result;

  RegisterResponseDatabase({this.result});

  factory RegisterResponseDatabase.fromJson(Map<String, dynamic> json) {
    return RegisterResponseDatabase(
      result: json['result'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result,
    };
  }
}
