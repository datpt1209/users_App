import 'dart:convert';

import 'message.dart';

class Trip {
  final String tripId;
  final String code;
  Message? messageObject;
  String? message;

  Trip({
    required this.tripId,
    required this.code,
    this.messageObject,
    this.message,
  });

  factory Trip.fromJson(Map<String, dynamic> jsonString) {
    if(jsonString['code'] == "trip.Picking")
    {
      Map<String, dynamic> jsonMessageData = json.decode(jsonString['message']);
      var messageData = Message.fromJson(jsonMessageData);
      return Trip(
        tripId: jsonString['trip'],
        code: jsonString['code'],
        messageObject: messageData ,
      );
    }
    else if(jsonString['code'] == "trip.Scheduled")
    {
      Map<String, dynamic> jsonMessageData = json.decode(jsonString['message']);
      var messageData = Message.fromJsonSchedule(jsonMessageData);
      return Trip(
        tripId: jsonString['trip'],
        code: jsonString['code'],
        messageObject: messageData ,
      );
    }
    else
    {
      return Trip(
        tripId: jsonString['trip'],
        code: jsonString['code'],
        message: jsonString['message'],
      );
    }
  }
}