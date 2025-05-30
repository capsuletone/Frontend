class RegisterResponseDatabase {
  String? result;

  RegisterResponseDatabase({this.result});

  factory RegisterResponseDatabase.fromJson(Map<String, dynamic> json) {
    final dynamic result = json['result'];
    return RegisterResponseDatabase(
      result: result is String ? result : result.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result,
    };
  }
}
