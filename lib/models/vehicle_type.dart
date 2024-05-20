import 'dart:convert';

class VehicleType {
  final String id;
  final String name;
  final int capacity;
  final double pricePerKm;

  const VehicleType({
    required this.id,
    required this.name,
    required this.capacity,
    required this.pricePerKm
  });

  factory VehicleType.fromJson(Map<String, dynamic> json){

    return VehicleType(
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

List<VehicleType> carTypeFromJson(String str) {
  final jsonData = json.decode(str);
  return List<VehicleType>.from(jsonData.map((x) => VehicleType.fromJson(x)));
}

String carTypeToJson(List<VehicleType> data) {
  final List dyn = List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}

