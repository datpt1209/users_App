
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/user_ride_Request_information.dart';

class NotificationDialogBox extends StatefulWidget
{
  UserRideRequestInformation? userRideRequestDetails;

  NotificationDialogBox({this.userRideRequestDetails});

  @override
  State<NotificationDialogBox> createState() => _NotificationDialogBoxState();
}

class _NotificationDialogBoxState extends State<NotificationDialogBox>
{
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.transparent,
      elevation: 2,
      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),

          color: Colors.grey[800],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 14,),
            Image.asset("images/car_logo.png", width: 160,),
            const SizedBox(height: 10,),
        //title
            const Text(
              "New Ride Request",
                style:  TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.grey
                ),
            ),

            const SizedBox(height: 20,),

            const Divider(
              height: 3,
              thickness: 3,
            ),

          //address origin destination
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  //origin location with icon
                  Row(
                    children: [
                      Image.asset("images/origin.png", width: 30, height: 30,),
                      const SizedBox(width: 22,),
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.userRideRequestDetails!.originAddress!,
                            style: const TextStyle(
                              fontSize: 16, color: Colors.grey
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25,),

                  //destination location with icon
                  Row(
                    children: [
                      Image.asset("images/destination.png", width: 30, height: 30,),
                      const SizedBox(width: 22,),
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.userRideRequestDetails!.destinationAddress!,
                            style: const TextStyle(
                              fontSize: 16, color: Colors.grey
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(
              height: 3,
              thickness: 3,
            ),

            //buttons
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: ()
                    {

                      //cancel the rideRequest
                      Navigator.pop(context);
                      canceltRideRequest(context);

                    },
                    child: Text(
                      "Cancel".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),

                  const SizedBox(width: 25,),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: ()
                    {
                      //accept the rideRequest
                      acceptRideRequest(context);

                    },
                    child: Text(
                      "Accept".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  acceptRideRequest(BuildContext context)
  {

  }
  canceltRideRequest(BuildContext context)
  {


  }

}
