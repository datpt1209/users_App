
class Driver {
  final String id;
  final String name;
  final String type;
  final String phone;

  Driver({
    required this.id,
    required this.name,
    required this.type,
    required this.phone,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      phone: json['phone'],
    );
  }
}