class Register {
  String? userid;
  String? password;
  String? username;
  String? registerdate;

  Register({this.userid, this.password, this.username, this.registerdate});

  factory Register.fromJson(Map<String, dynamic> json) {
    return Register(
      userid: json['userid'],
      password: json['password'],
      username: json['username'],
      registerdate: json['registerdate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userid': userid,
      'password': password,
      'username': username,
      'registerdate': registerdate,
    };
  }
}
