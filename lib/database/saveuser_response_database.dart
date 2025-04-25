class SaveUserResponseDatabase {
  bool? result;

  SaveUserResponseDatabase({this.result});

  factory SaveUserResponseDatabase.fromJson(Map<String, dynamic> json) {
    return SaveUserResponseDatabase(
      result: json['result'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result,
    };
  }
}
