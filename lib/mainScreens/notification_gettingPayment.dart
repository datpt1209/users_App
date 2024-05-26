import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../splashScreen/splash_screen.dart';

class NotificationConfirmPayment extends StatefulWidget
{
  String message;
  String code;
  NotificationConfirmPayment({required this.message , required this.code});

  @override
  State<NotificationConfirmPayment> createState() => _NotificationConfirmPaymentState();
}

class _NotificationConfirmPaymentState extends State<NotificationConfirmPayment>
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
              "Payment Information",
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
                      const SizedBox(width: 22,),
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.message.toString(),
                            style: const TextStyle(
                                fontSize: 30, color: Colors.grey
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
                      //acceptRideRequest(context);
                    },
                    child: Text(
                      "Ok".toUpperCase(),
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

  // acceptRideRequest(BuildContext context)
  // async {
  //   if(widget.code == 'trip.Done')
  //   {
  //     Navigator.push(context, MaterialPageRoute(builder: (c)=>MySplashScreen()));
  //   }
  //   else
  //   {
  //     await confirmPayment();
  //     Navigator.pop(context);
  //   }
  //
  // }
  canceltRideRequest(BuildContext context)
  {
    Navigator.pop(context);
  }
  // confirmPayment()
  // async {
  //   var body = jsonEncode("");
  //   print("Body::::::::${body}");
  //   var uri = ('http://209.38.168.38/trip/driver/confirm-payment/${userRideRequestDetails!.id}?driver_id=${currentDriver!.id}');
  //   print("URL: ${uri}");
  //   var response = await http.post(Uri.parse(uri),
  //       headers: {"Content-Type": "application/json"},
  //       body: body
  //   );
  //   if(response.statusCode == 200){
  //     Fluttertoast.showToast(msg: "Payment successfully");
  //   }
  //   else{
  //     Fluttertoast.showToast(msg: "Error Occurred during Confirm-payment Trip");
  //     throw Exception('Failed to Confirm-payment Trip');
  //   }
  // }

}