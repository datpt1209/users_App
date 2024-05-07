import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/global/global.dart';
import '../splashScreen/splash_screen.dart';
import '../widgets/progress_dialog.dart';
import 'package:http/http.dart' as http;

class UpdateInformation extends StatefulWidget {
  const UpdateInformation({super.key});

  @override
  State<UpdateInformation> createState() => _UpdateInformationState();
}

class _UpdateInformationState extends State<UpdateInformation> {

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController addressTextEditingController = TextEditingController();
  TextEditingController pictureTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 10,),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("images/logo.png"),
              ),

              const SizedBox(height: 10,),
              const Text(
                "Update Information",
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: nameTextEditingController,
                style: const TextStyle(
                  color: Colors.grey
                ),
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  hintText: "FullName",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintStyle:  TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  labelStyle:TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ),
              TextField(
                controller: addressTextEditingController,
                keyboardType: TextInputType.text,
                style: const TextStyle(
                    color: Colors.grey
                ),
                decoration: const InputDecoration(
                  labelText: "Address",
                  hintText: "Address",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintStyle:  TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  labelStyle:TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ),

              TextField(
                controller: pictureTextEditingController,
                keyboardType: TextInputType.text,
                style: const TextStyle(
                    color: Colors.grey
                ),
                decoration: const InputDecoration(
                  labelText: "Picture",
                  hintText: "Picture",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintStyle:  TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  labelStyle:TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ),

              const SizedBox(height: 20,),
              ElevatedButton
                (
                onPressed: ()
                {
                  validateForm();
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.lightGreenAccent
                ),
                child:const Text(
                  "Update Information",
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  validateForm()
  {
      if(nameTextEditingController.text.length < 3)
    {
      Fluttertoast.showToast(msg: "Name must be at least 3 charaters");
    }
    else if(addressTextEditingController.text.length < 5)
    {
      Fluttertoast.showToast(msg: " Address is not Valid");
    }
    else
    {
      saveUserInfoNow();
    }
  }
  saveUserInfoNow() async
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c)
        {
          return ProgressDialog(message: "Processing, Please wait...",);
        }
    );

    Map userMap =
    {
      "fullName": nameTextEditingController.text.trim(),
      "address": addressTextEditingController.text.trim(),
      "picture": pictureTextEditingController.text.trim(),
      "userId": currentUser_API?.id,
      "mobilePhone": currentUser_API?.mobilePhone
    };
    var body = json.encode(userMap);

    //Call API update information
    var response = await http.post(Uri.parse('http://209.38.168.38/account/api/v1/customer/update'),
        headers: {"Content-Type": "application/json"},
        body: body
    );
    if(response.statusCode == 200){
      currentUser_API?.address = addressTextEditingController.text.trim();
      currentUser_API?.fullName = nameTextEditingController.text.trim();
      Fluttertoast.showToast(msg: "Login Successfully");
      Navigator.push(context, MaterialPageRoute(builder: (c)=>MySplashScreen()));

    }else{
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error Occurred during Login");
      throw Exception('Failed to login with Customer');
    }
  }
}
