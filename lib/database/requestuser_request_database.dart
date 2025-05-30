class RequestuserRequestDatabase {
  String? userid;

  RequestuserRequestDatabase({this.userid});

  factory RequestuserRequestDatabase.fromJson(Map<String, dynamic> json) {
    return RequestuserRequestDatabase(
      userid: json['userid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userid': userid,
    };
  }
}
