import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../global/global.dart';
import '../splashScreen/splash_screen.dart';
import '../widgets/progress_dialog.dart';

class NotificationCancelTrip extends StatefulWidget
{
  NotificationCancelTrip();

  @override
  State<NotificationCancelTrip> createState() => _NotificationCancelTripState();
}

class _NotificationCancelTripState extends State<NotificationCancelTrip>
{
  TextEditingController reasonTextEditingController = TextEditingController();

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
            Image.asset("images/logo.png", width: 160,),
            const SizedBox(height: 10,),
            //title
            const Text(
              "Cancel Trip",
              style:  TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.grey
              ),
            ),

            const SizedBox(height: 10,),

            const Divider(
              height: 2,
              thickness: 2,
            ),

            //address origin destination
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  //origin location with icon
                  TextField(
                    controller: reasonTextEditingController,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(
                        color: Colors.grey
                    ),
                    decoration: const InputDecoration(
                      labelText: "Please write your Reason:",
                      hintText: "Reason",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      hintStyle:  TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                      labelStyle:TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
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
                      cancelRideRequest(context);
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

  cancelRideRequest(BuildContext context)
  async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c)
        {
          return ProgressDialog(message: "Cancel trip, Please wait...",);
        }
    );
    Map customer = {
      "id": currentUser_API_Info!.id.toString(),
      "name": currentUser_API_Info!.fullName.toString(),
      "phone": currentUser_API_Info!.mobilePhone.toString(),
      "rank": "NORMAL",
      "type": "customer",
    };
    Map request = {
      "reason": reasonTextEditingController.text.trim(),
      "requester": customer
    };
    var body = json.encode(request);
    var uri = 'http://209.38.168.38/trip/cancel/${currentTrip!.tripId}';
    var response = await http.post(
        Uri.parse(uri),
        headers: {"Content-Type": "application/json"},
        body: body);
    print(uri);
    print("Cancel request:::::::::::${body}");
    if (response.statusCode == 200) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Cancel Trip Success");
      Navigator.push(context, MaterialPageRoute(builder: (c)=>MySplashScreen()));
    } else {

      Fluttertoast.showToast(msg: "Error Occurred during Cancel");
      Navigator.pop(context);
      throw Exception('Failed to cancel trip');

    }
  }



}