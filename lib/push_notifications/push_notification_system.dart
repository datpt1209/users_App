/*
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:drivers_app/global/global.dart';
import 'package:drivers_app/models/user_ride_Request_information.dart';
import 'package:drivers_app/push_notifications/notification_dialog_box.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotificationSystem
{
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initializeCloudMessaging(BuildContext context) async
  {
    //1. Terminated
    //When the app is completely closed and opened directly from the push notification
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? remoteMessage)
    {
      if(remoteMessage != null)
      {
        //display ride request information - user information who request a ride
        readUserRideRequestInformation(remoteMessage.data["rideRequestId"],context);
        print("The remotesegar:::" + remoteMessage.toString());
      }
    });
    //2. Foreground
    //when the app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage)
    {
      //display ride request information - user information who request a ride
      readUserRideRequestInformation(remoteMessage!.data["rideRequestId"], context);
    });

    //3.Background
    //when the app is in the background and opened directly from the push notification.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage)
    {
      //display ride request information - user information who request a ride
      readUserRideRequestInformation(remoteMessage!.data["rideRequestId"],context);
    });
  }

  readUserRideRequestInformation(String userRideRequestId, BuildContext context)
  {
    FirebaseDatabase.instance.ref().child("All Ride Requests")
        .child(userRideRequestId)
        .once()
        .then((snapData)
    {
      if(snapData.snapshot.value != null)
      {
        audioPlayer.open(Audio("music/music_notification.mp3"));
        audioPlayer.play();

       double originLat = double.parse((snapData.snapshot.value! as Map)["origin"]["latitude"].toString());
       double originLng = double.parse((snapData.snapshot.value! as Map)["origin"]["longitude"].toString());
       String originAddress = (snapData.snapshot.value! as Map)["originAddress"];

       double destinationLat = double.parse((snapData.snapshot.value! as Map)["destination"]["latitude"].toString());
       double destinationLng = double.parse((snapData.snapshot.value! as Map)["destination"]["longitude"].toString());
       String destinationAddress = (snapData.snapshot.value! as Map)["destinationAddress"];

       String userName = (snapData.snapshot.value! as Map)["userName"];
       String userPhone = (snapData.snapshot.value! as Map)["userPhone"];

       String? rideRequestId = snapData.snapshot.key;

       UserRideRequestInformation userRideRequestDetails = UserRideRequestInformation();
       userRideRequestDetails.originLatLng = LatLng(originLat, originLng);
       userRideRequestDetails.originAddress = originAddress;
       userRideRequestDetails.destinationLaLng = LatLng(destinationLat, destinationLng);
       userRideRequestDetails.destinationAddress = destinationAddress;
       userRideRequestDetails.userName = userName;
       userRideRequestDetails.userPhone = userPhone;
       userRideRequestDetails.rideRequestId = rideRequestId;

       showDialog(
           context: context,
           builder: (BuildContext context) => NotificationDialogBox(
             userRideRequestDetails: userRideRequestDetails,
         ),
       );
      }
      else
      {
        Fluttertoast.showToast(msg: "This Ride Request Id do not exists");
      }
    });
  }

  Future generateAndGetToken() async
  {
    String? registrationToken = await messaging.getToken();
    print("FCM Registration Token: ");
    print(registrationToken);
    //send token to server

    //

    FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("token")
        .set(registrationToken);

    messaging.subscribeToTopic("allDrivers");
    messaging.subscribeToTopic("allUsers");
  }
}
*/

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:users_app/mainScreens/main_screen.dart';

import '../models/user_ride_Request_information.dart';
import 'notification_dialog_box.dart';

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

class VehicleType {
  final String id;
  final String name;
  final int capacity;
  final double pricePerKm;

  VehicleType({
    required this.id,
    required this.name,
    required this.capacity,
    required this.pricePerKm,
  });

  factory VehicleType.fromJson(Map<String, dynamic> json) {
    return VehicleType(
      id: json['id'],
      name: json['name'],
      capacity: json['capacity'],
      pricePerKm: json['price_per_km'].toDouble(),
    );
  }
}

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

class PushNotificationSystem
{
  MainScreenState mainScreen = MainScreenState();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initializeCloudMessaging(BuildContext context) async
  {
    //1. Terminated
    //When the app is completely closed and opened directly from the push notification
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? remoteMessage)
    {
      if(remoteMessage != null)
      {
        //display ride request information - user information who request a ride
        print("This is Ride request::::::");
        print(remoteMessage!.data.toString());
        mainScreen.readUserRideRequestInformation(remoteMessage, context);
      }
    });
    //2. Foreground
    //when the app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage)
    {
      //display ride request information - user information who request a ride
      print("This is Ride request::::::");
      print(remoteMessage!.data.toString());
      mainScreen.readUserRideRequestInformation(remoteMessage, context);
    });

    //3.Background
    //when the app is in the background and opened directly from the push notification.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage)
    {
      //display ride request information - user information who request a ride
      print("This is Ride request::::::");
      print(remoteMessage!.data.toString());
      mainScreen.readUserRideRequestInformation(remoteMessage, context);
    });
  }

  // readUserRideRequestInformation(RemoteMessage remoteMessage, BuildContext context)
  // {
  //   var jsonString = remoteMessage.data['data'].toString();
  //   final Map<String, dynamic> parsed = json.decode(jsonString);
  //   var trip = Trip.fromJson(parsed);
  //
  //   if(trip.code == "trip.Picking")
  //   {
  //    var message = trip.messageObject!;
  //     print("Driver Information::::::::::${message.driver.name} - ${message.driver.phone}");
  //     // double originLong = double.parse(origination['longitude']);
  //
  //   }
  //   else
  //   {
  //     var message = trip.message!;
  //     print("This is Message:::::::::${message}");
  //     // double originLong = double.parse(origination['longitude']);
  //   }
  //
  //   // var originAddress = remoteMessage.data['pickingAddress'].toString();
  //   // var origination =jsonDecode(remoteMessage.data["origin"].toString());
  //   // double originLat = double.parse(origination['latitude']);
  //   // double originLong = double.parse(origination['longitude']);
  //   //
  //   // var destinationAddress = remoteMessage.data['destinationAddress'].toString();
  //   // var destination =jsonDecode(remoteMessage.data["destination"].toString());
  //   // double destinationLat = double.parse(destination['latitude']);
  //   // double destinationLong = double.parse(destination['longitude']);
  //   //
  //   // UserRideRequestInformation userRideRequestDetails = UserRideRequestInformation();
  //   // userRideRequestDetails.originLatLng = LatLng(originLat, originLong);
  //   // userRideRequestDetails.originAddress = originAddress;
  //   // userRideRequestDetails.destinationAddress = destinationAddress;
  //   // userRideRequestDetails.destinationLaLng = LatLng(destinationLat, destinationLong);
  //   //
  //   // print("this is latitude::::::::::${originAddress}");
  //
  //   // showDialog(
  //   //     context: context,
  //   //     builder: (BuildContext context) => NotificationDialogBox(
  //   //       userRideRequestDetails: userRideRequestDetails,
  //   //     ),
  //   // );
  // }
  //

  Future generateAndGetToken() async
  {
    String? registrationToken = await messaging.getToken();
    print("FCM Registration Token: ");
    print(registrationToken);


    messaging.subscribeToTopic("allDrivers");
    messaging.subscribeToTopic("allUsers");
  }
}

