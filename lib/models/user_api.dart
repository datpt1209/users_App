import 'package:firebase_database/firebase_database.dart';

class UserModel_API
{
  final int id;
  final String mobilePhone;
  String? fullName;
  String? email;

  UserModel_API({
    required this.id,
    required this.mobilePhone,
    this.fullName,
    this.email
  });

  factory UserModel_API.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'mobilePhone': String mobilePhone,
      } =>
          UserModel_API(
              id: id,
              mobilePhone: mobilePhone,
          ),
      _ => throw const FormatException('Failed to load User.'),
    };
  }

  Map<String, dynamic> toJson() =>
      {
        "id":id,
        "mobilePhone": mobilePhone,
        "fullName": fullName,
        "email": email
      };
}