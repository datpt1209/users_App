import 'dart:convert';

class CarType {
  final String id;
  final String name;
  final int capacity;
  final double pricePerKm;

  const CarType({
    required this.id,
    required this.name,
    required this.capacity,
    required this.pricePerKm
  });

  factory CarType.fromJson(Map<String, dynamic> json){

    return CarType(
        id: json['_id'].toString(),
        name: json['name'].toString(),
        capacity: json['capacity'],
        pricePerKm: json['price_per_km'] as double
    );
  }

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "name": name,
        "capacity": capacity,
        "price_per_km": pricePerKm
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