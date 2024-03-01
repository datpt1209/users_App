import 'dart:convert';

List<CarType> carTypeFromJson(String str) {
  final jsonData = json.decode(str);
  return new List<CarType>.from(jsonData.map((x) => CarType.fromJson(x)));
}

String carTypeToJson(List<CarType> data) {
  final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}

class CarType {
  int? id;
  String? name;
  int? capaticy;
  String? is_deleted;

  CarType({
    this.id,
    this.name,
    this.capaticy,
    this.is_deleted
  });

  factory CarType.fromJson(Map<String, dynamic> json){
    return new CarType(
        id: json['id'],
        name: json['name'].toString(),
        capaticy: json['capaticy'],
        is_deleted: json['is_deleted'].toString()
    );
  }

    Map<String, dynamic> toJson() =>
        {
          "id": id,
          "name": name,
          "capaticy": capaticy,
          "is_deleted": is_deleted
        };
  }

