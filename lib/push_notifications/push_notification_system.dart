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
import 'package:provider/provider.dart';
import 'package:users_app/global/global.dart';
import '../infoHandler/app_info.dart';
import '../models/trip.dart';


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
        print("This is Ride request::::::");
        print(remoteMessage!.data.toString());

        readUserRideRequestInformation(remoteMessage, context);
      }
    });
    //2. Foreground
    //when the app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage)
    {
      //display ride request information - user information who request a ride
      print("This is Ride request::::::");
      print(remoteMessage!.data.toString());
      readUserRideRequestInformation(remoteMessage, context);
    });

    //3.Background
    //when the app is in the background and opened directly from the push notification.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage)
    {
      //display ride request information - user information who request a ride
      print("This is Ride request::::::");
      print(remoteMessage!.data.toString());
     readUserRideRequestInformation(remoteMessage, context);
    });
  }

  Future generateAndGetToken() async
  {
    String? registrationToken = await messaging.getToken();
    print("FCM Registration Token: ");
    print(registrationToken);
    messaging.subscribeToTopic("allDrivers");
    messaging.subscribeToTopic("allUsers");
  }

  readUserRideRequestInformation(RemoteMessage remoteMessage, BuildContext context)
  {
    var jsonString = remoteMessage.data['data'].toString();
    final Map<String, dynamic> parsed = json.decode(jsonString);
    currentTrip = Trip.fromJson(parsed);

    if(currentTrip!.code == "trip.Picking")
    {
      var message = currentTrip!.messageObject!;
      print("Driver Information::::::::::${message.driver.name} - ${message.driver.phone}");
      // double originLong = double.parse(origination['longitude']);
    }
    else
    {
      var message = currentTrip!.message!;
      print("This is Message:::::::::${message}");
      // double originLong = double.parse(origination['longitude']);
    }
  }
}

