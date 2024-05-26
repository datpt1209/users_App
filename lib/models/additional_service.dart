import 'dart:convert';

class AdditionalService {
  final String id;
  final String name;
  final double price;
  final String type;

  const AdditionalService({
    required this.id,
    required this.name,
    required this.price,
    required this.type
  });

  factory AdditionalService.fromJson(Map<String, dynamic> json){

    return AdditionalService(
        id: json['_id'].toString(),
        name: json['name'].toString(),
        price: double.parse(json['price'].toString()),
        type: json['type'].toString()
    );
  }

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "name": name,
        "price": price,
        "type": type
      };
}

List<AdditionalService> additionalServicesFromJson(String str) {
  final jsonData = json.decode(str);
  return List<AdditionalService>.from(jsonData.map((x) => AdditionalService.fromJson(x)));
}

String additionalServicesToJson(List<AdditionalService> data) {
  final List dyn = List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}

