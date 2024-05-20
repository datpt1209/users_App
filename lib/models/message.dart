import 'driver.dart';
import 'vehicle.dart';

class Message {
  final Vehicle vehicle;
  final Driver driver;
  final String etaPicking;
  final String etaDestination;

  Message({
    required this.vehicle,
    required this.driver,
    required this.etaPicking,
    required this.etaDestination,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      vehicle: Vehicle.fromJson(json['vehicle']),
      driver: Driver.fromJson(json['driver']),
      etaPicking: json['eta_picking'],
      etaDestination: json['eta_destination'],
    );
  }
}