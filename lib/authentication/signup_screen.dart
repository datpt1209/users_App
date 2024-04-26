
/*import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/authentication/login_screen.dart';
import 'package:users_app/authentication/updateInformartion_screen.dart';
import 'package:users_app/models/user_api.dart';
import 'package:users_app/splashScreen/splash_screen.dart';
import 'package:http/http.dart' as http;
import '../global/global.dart';
import '../widgets/progress_dialog.dart';


class SignUpScreen extends StatefulWidget
{
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
{
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

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
                "Register as a Driver",
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
                  labelText: "Name",
                  hintText: "Name",
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
                controller: phoneTextEditingController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(
                    color: Colors.grey
                ),
                decoration: const InputDecoration(
                  labelText: "Phone",
                  hintText: "Phone",
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
                    "Create Account",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18
                    ),
                  ),
              ),
              TextButton(
                child: const Text(
                  "Already have an Account? Login Here",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (c)=>LoginScreen()));
                },
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
    else if(!emailTextEditingController.text.contains("@"))
    {
      Fluttertoast.showToast(msg: "Email address is not Valid");
    }
    if(phoneTextEditingController.text.isEmpty)
    {
      Fluttertoast.showToast(msg: "Phone Number is require.");
    }
    else if(passwordTextEditingController.text.length < 6)
    {
      Fluttertoast.showToast(msg: "Password must be at least 6 Characters .");
    }
    else
    {
      saveUserInfoNow();
    }
  }

  //save User to FireBase

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

    final User? firebaseUser = (
        await fAuth.createUserWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim(),
        ).catchError((msg){
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Error: " + msg.toString());
        })
    ).user;

    if(firebaseUser != null)
    {
      Map userMap =
      {
        "id": firebaseUser.uid,
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };

      DatabaseReference reference =  FirebaseDatabase.instance.ref().child("users");
      reference.child(firebaseUser.uid).set(userMap);

      currentFirebaseUser = firebaseUser;
      Fluttertoast.showToast(msg: "Account has been Created.");
      Navigator.push(context, MaterialPageRoute(builder: (c)=>MySplashScreen()));


    }
    else
    {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Account has not been Created.");
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
     /* "fullName": nameTextEditingController.text.trim(),
      "email": emailTextEditingController.text.trim(),*/
      "mobilePhone": phoneTextEditingController.text.trim(),
      "password": passwordTextEditingController.text.trim(),
      "type": "CUSTOMER"
    };
    var body = json.encode(userMap);
    print("body:::: ${body}");
    var response = await http.post(Uri.parse('http://35.185.184.72/account/api/v1/register'),
        headers: {"Content-Type": "application/json"},
        body: body
    );

    print("${response.statusCode}");
    print("${response.body}");

    if(response.statusCode == 200){
      currentUser_API =  await UserModel_API.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      print("UserID::::::: ${currentUser_API?.id}");
      UserModel_API userModel_API = await UserModel_API.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      print("UserID::::::: ${userModel_API.id}");
      print("UserPhone::::::: ${userModel_API.mobilePhone}");
      Fluttertoast.showToast(msg: "Account has been Created: ${userModel_API.id}");
      Navigator.push(context, MaterialPageRoute(builder: (c)=>UpdateInformation()));

    }else{
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Account has not been Created.");
      throw Exception('Failed to create Customer');
    }
  }

}
*/

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/authentication/login_screen.dart';
import 'package:users_app/authentication/updateInformartion_screen.dart';
import 'package:users_app/models/user_api.dart';
import 'package:http/http.dart' as http;
import '../global/global.dart';
import '../widgets/progress_dialog.dart';


class SignUpScreen extends StatefulWidget
{
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
{
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

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
              "Register as a Driver",
              style: TextStyle(
                fontSize: 26,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
        TextField(
        controller: phoneTextEditingController,
        keyboardType: TextInputType.phone,
        style: const TextStyle(
        color: Colors.grey
        ),
        decoration: const InputDecoration(
          labelText: "Phone",
          hintText: "Phone",
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
          "Create Account",
          style: TextStyle(
              color: Colors.black54,
              fontSize: 18
          ),
        ),
      ),
      TextButton(
        child: const Text(
          "Already have an Account? Login Here",
          style: TextStyle(color: Colors.grey),
        ),
        onPressed: ()
        {
          Navigator.push(context, MaterialPageRoute(builder: (c)=>LoginScreen()));
        },
      ),
      ],
    ),
    ),
    ),
    );
  }
  validateForm()
  {
    if(phoneTextEditingController.text.isEmpty)
    {
      Fluttertoast.showToast(msg: "Phone Number is require.");
    }
    else if(passwordTextEditingController.text.length < 6)
    {
      Fluttertoast.showToast(msg: "Password must be at least 6 Characters .");
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
      "mobilePhone": phoneTextEditingController.text.trim(),
      "password": passwordTextEditingController.text.trim(),
      "type": "CUSTOMER"
    };
    var body = json.encode(userMap);
    print("body:::: ${body}");
    var response = await http.post(Uri.parse('http://4.144.131.165/account/api/v1/register'),
        headers: {"Content-Type": "application/json"},
        body: body
    );
    print("${response.statusCode}");
    print("${response.body}");

    if(response.statusCode == 200){
      currentUser_API =  await UserModel_API.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      print("UserID::::::: ${currentUser_API?.id}");
      UserModel_API userModel_API = await UserModel_API.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      print("UserID::::::: ${userModel_API.id}");
      print("UserPhone::::::: ${userModel_API.mobilePhone}");
      Fluttertoast.showToast(msg: "Account has been Created: ${userModel_API.id}");
      Navigator.push(context, MaterialPageRoute(builder: (c)=>UpdateInformation()));

    }else{
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Account has not been Created.");
      throw Exception('Failed to create Customer');
    }
  }

}

