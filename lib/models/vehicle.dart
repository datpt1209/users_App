import 'vehicle_type.dart';

class Vehicle {
  final String make;
  final String model;
  final VehicleType vehicleType;
  final String vehicleNumber;
  final String status;
  final List<double> currentLocation;
  final double avgSpeed;

  Vehicle({
    required this.make,
    required this.model,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.status,
    required this.currentLocation,
    required this.avgSpeed,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      make: json['make'],
      model: json['model'],
      vehicleType: VehicleType.fromJson(json['vehicle_type']),
      vehicleNumber: json['vehicle_number'],
      status: json['status'],
      currentLocation: List<double>.from(json['current_location'].map((c) => c.toDouble())),
      avgSpeed: json['avg_speed'].toDouble(),
    );
  }
}