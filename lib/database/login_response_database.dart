class LoginResponseDatabase {
  bool? result;

  LoginResponseDatabase({this.result});

  factory LoginResponseDatabase.fromJson(Map<String, dynamic> json) {
    return LoginResponseDatabase(
      result: json['result'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result,
    };
  }
}
