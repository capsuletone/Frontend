class Login {
  String? userid;
  String? password;

  Login({
    this.userid,
    this.password,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      userid: json['userid'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userid': userid,
      'password': password,
    };
  }
}
