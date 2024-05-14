
class UserModel_API
{
  final int id;
  String? mobilePhone;
  String? fullName;
  String? picture;
  String? address;

  UserModel_API({
    required this.id,
    this.mobilePhone,
    this.fullName,
    this.picture,
    this.address
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
      _ => throw Exception('Failed to load User.'),
    };
  }

  factory UserModel_API.fromJsonInfo(Map<String, dynamic> json) {
    return switch (json) {
      {
      'userId': int id,
      'mobilePhone': String mobilePhone,
      'fullName': String fullName,
      'picture':String picture,
      'address': String address
      } =>
          UserModel_API(
            id: id,
            mobilePhone: mobilePhone,
            fullName: fullName,
            address: address,
            picture: picture
          ),
      _ => throw Exception('Failed to load User.'),
    };
  }


  Map<String, dynamic> toJson() =>
      {
        "id":id,
        "mobilePhone": mobilePhone,
        "fullName": fullName,
        "picture": picture,
        'address': address
      };
}