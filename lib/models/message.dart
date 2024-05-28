import 'driver.dart';
import 'vehicle.dart';

class Message {
  final Vehicle vehicle;
  final Driver driver;
  final String? etaPicking;
  final String? etaDestination;
  final String? pickupTime;

  Message({
    required this.vehicle,
    required this.driver,
     this.etaPicking,
     this.etaDestination,
     this.pickupTime
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      vehicle: Vehicle.fromJson(json['vehicle']),
      driver: Driver.fromJson(json['driver']),
      etaPicking: json['eta_picking'],
      etaDestination: json['eta_destination'],
    );
  }
  factory Message.fromJsonSchedule(Map<String, dynamic> json) {
    return Message(
        vehicle: Vehicle.fromJson(json['vehicle']),
        driver: Driver.fromJson(json['driver']),
        pickupTime: json['pickup_time']
    );
  }
}