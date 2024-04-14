/*
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/authentication/signup_screen.dart';
import 'package:users_app/splashScreen/splash_screen.dart';
import 'package:http/http.dart' as http;

import '../global/global.dart';
import '../widgets/progress_dialog.dart';


class LoginScreen extends StatefulWidget
{
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
{
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm()
  {
    if(!emailTextEditingController.text.contains("@"))
    {
      Fluttertoast.showToast(msg: "Email address is not Valid");
    }
    else if(passwordTextEditingController.text.isEmpty)
    {
      Fluttertoast.showToast(msg: "Password is required.");
    }
    else
    {
      loginUserNow();
    }
  }

  // loginUserNow() async
  // {
  //     http.Response httpResponse = await http.get(Uri.parse('http://35.185.184.72/test'));
  //
  //         String responseData = httpResponse.body; //json
  //         //var decodeResponseData = jsonDecode(responseData);
  //         print(responseData);
  // }


  loginUserNow() async
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c)
        {
          return ProgressDialog(message: "Login, Please wait...",);
        }
    );

    final User? firebaseUser = (
        await fAuth.signInWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim(),
        ).catchError((msg){
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Error: " + msg.toString());
        })
    ).user;

    if(firebaseUser != null)
    {
      DatabaseReference usersRef =  FirebaseDatabase.instance.ref().child("users");
      usersRef.child(firebaseUser.uid).once().then((userKey)
      {
        final snap = userKey.snapshot;
        if(snap.value != null)
        {
          currentFirebaseUser = firebaseUser;
          Fluttertoast.showToast(msg: "Login successful.");
          Navigator.push(context, MaterialPageRoute(builder: (c)=>const MySplashScreen()));
        }
        else
        {
          Fluttertoast.showToast(msg: "No record exits with this email");
          fAuth.signOut();
          Navigator.push(context, MaterialPageRoute(builder: (c)=>const MySplashScreen()));
        }
      });
    }
    else
    {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error Occurred during Login");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 30,),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("images/logo.png"),
              ),
              const SizedBox(height: 10,),
              const Text(
                "Login as a User",
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                    color: Colors.grey
                ),
                decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "Email",
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
                controller: passwordTextEditingController,
                keyboardType: TextInputType.text,
                obscureText: true,
                style: const TextStyle(
                    color: Colors.grey
                ),
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "Password",
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
                  //Navigator.push(context,MaterialPageRoute(builder: (c)=> CarInfoScreen()));
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.lightGreenAccent
                ),
                child:const Text(
                  "Login",
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18
                  ),
                ),
              ),
              TextButton(
                  child: const Text(
                    "Do not have an Account? SignUp Here",
                    style: TextStyle(color: Colors.grey),
                  ),
                onPressed: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (c)=>SignUpScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/authentication/signup_screen.dart';
import 'package:users_app/authentication/updateInformartion_screen.dart';
import 'package:users_app/mainScreens/main_screen.dart';
import 'package:users_app/splashScreen/splash_screen.dart';
import 'package:http/http.dart' as http;

import '../global/global.dart';
import '../models/user_api.dart';
import '../widgets/progress_dialog.dart';


class LoginScreen extends StatefulWidget
{
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
{
  TextEditingController mobilePhoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm()
  {
    if(mobilePhoneTextEditingController.text.isEmpty)
    {
      Fluttertoast.showToast(msg: "Phone Number is require.");
    }
    else if(passwordTextEditingController.text.length < 6)
    {
      Fluttertoast.showToast(msg: "Password must be at least 6 Characters .");
    }
    else
    {
      loginUserNow();
    }
  }
  loginUserNow() async
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c)
        {
          return ProgressDialog(message: "Login, Please wait...",);
        }
    );
    Map userMap =
    {
      "mobilePhone": mobilePhoneTextEditingController.text.trim(),
      "password": passwordTextEditingController.text.trim(),
      "type": "CUSTOMER"
    };
    var body = json.encode(userMap);
    print("body:::: ${body}");
    var response = await http.post(Uri.parse('http://34.142.183.254/account/api/v1/login'),
        headers: {"Content-Type": "application/json"},
        body: body
    );

    print("${response.statusCode}");
    print("${response.body}");

    if(response.statusCode == 200){
      currentUser_API = await UserModel_API.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      print("UserID::::::: ${currentUser_API?.id}");
      print("UserPhone::::::: ${currentUser_API?.mobilePhone}");
      Fluttertoast.showToast(msg: "Login Successfully with CustomerID: ${currentUser_API?.id}");
      Navigator.push(context, MaterialPageRoute(builder: (c)=>MainScreen()));

    }else{
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error Occurred during Login");
      throw Exception('Failed to login with Customer');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 30,),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("images/logo.png"),
              ),
              const SizedBox(height: 10,),
              const Text(
                "Login as a User",
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: mobilePhoneTextEditingController,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                    color: Colors.grey
                ),
                decoration: const InputDecoration(
                  labelText: "Mobile Phone",
                  hintText: "Mobile phone",
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
                controller: passwordTextEditingController,
                keyboardType: TextInputType.text,
                obscureText: true,
                style: const TextStyle(
                    color: Colors.grey
                ),
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "Password",
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
                  "Login",
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18
                  ),
                ),
              ),
              TextButton(
                child: const Text(
                  "Do not have an Account? SignUp Here",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (c)=>SignUpScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

