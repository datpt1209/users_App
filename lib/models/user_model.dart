import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';

class UserModel
{
  String? phone;
  String? name;
  String? id;
  String? email;

  UserModel({this.phone, this.name, this.id, this.email});

  UserModel.fromSnaphot(DataSnapshot snap)
  {
    phone = (snap.value as dynamic)["phone"];
    name = (snap.value as dynamic)["name"];
    id = snap.key;
    email = (snap.value as dynamic)["email"];
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'phone': String phone,
      'name': String name,
      'id': String id,
      'email': String email
      } =>
          UserModel(
            id: id,
            name: name,
            phone: phone,
            email: email
          ),
      _ => throw const FormatException('Failed to load User.'),
    };
  }

}