import 'package:firebase_database/firebase_database.dart';

class UserModel_API
{
  String? mobilePhone;
  String fullName;
  String? address;
  String? password;
  String? picture;
  String? id;
  String? email;

  UserModel_API({
    this.mobilePhone,
    required this.fullName,
    this.address,
    this.email,
    this.picture,
    this.password
  });

  // UserModel.fromSnaphot(DataSnapshot snap)
  // {
  //   phone = (snap.value as dynamic)["phone"];
  //   name = (snap.value as dynamic)["name"];
  //   id = snap.key;
  //   email = (snap.value as dynamic)["email"];
  // }

  factory UserModel_API.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      //'mobilePhone': String? mobilePhone,
      'fullName': String fullName,
      //'email': String? email,
      //'address': String? address,
      //'password': String? password
      } =>
          UserModel_API(
              fullName: fullName,
              // mobilePhone: mobilePhone,
              // email: email,
              // password: password,
              // address: address
          ),
      _ => throw const FormatException('Failed to load User.'),
    };
  }

  Map<String, dynamic> toJson() =>
      {
        "fullName": fullName,
        "password": password,
        "address": address,
        "email": email,
        "mobilePhone": mobilePhone
      };
}