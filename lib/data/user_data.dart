import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  UserData({
    required this.userEmail,
    required this.userName,
    //will be added
  });
  final String userEmail;
  final String userName;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        userEmail: json["UserEmail"],
        userName: json["UserName"],
      );

  Map<String, dynamic> toJson() => {
        "UserEmail": userEmail,
        "UserName": userName,
      };
}
