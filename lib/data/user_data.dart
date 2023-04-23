import 'dart:convert';

UserData incomeFromJson(String str) => UserData.fromJson(json.decode(str));

String incomeToJson(UserData data) => json.encode(data.toJson());

class UserData {
  UserData({
    required this.userEmail,
    //will be added
  });
  final String userEmail;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        userEmail: json["UserEmail"],
      );

  Map<String, dynamic> toJson() => {
        "UserEmail": userEmail,
      };
}
