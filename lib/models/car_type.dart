import 'dart:convert';

class CarType {
  final int id;
  final String name;
  final int capacity;
  final String is_deleted;

  const CarType({
    required this.id,
    required this.name,
    required this.capacity,
    required this.is_deleted
  });

  factory CarType.fromJson(Map<String, dynamic> json){

    return CarType(
        id: json['id'],
        name: json['name'].toString(),
        capacity: json['capacity'],
        is_deleted: json['is_deleted'].toString()
    );
  }

    Map<String, dynamic> toJson() =>
        {
          "id": id,
          "name": name,
          "capacity": capacity,
          "is_deleted": is_deleted
        };
  }

List<CarType> carTypeFromJson(String str) {
  final jsonData = json.decode(str);
  return List<CarType>.from(jsonData.map((x) => CarType.fromJson(x)));
}

String carTypeToJson(List<CarType> data) {
  final List dyn = List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}

