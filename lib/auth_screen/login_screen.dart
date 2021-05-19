import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:notifications/components/round_button.dart';
import 'package:notifications/home_page.dart';

import '../constants.dart';
import '../main.dart';


class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 48.0,
                  ),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      //Do something with the user input.
                      email = value;
                    },
                    decoration: kInputTextDecoration.copyWith(
                        hintText: 'Enter your email'),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    obscureText: true,
                    onChanged: (value) {
                      //Do something with the user input.
                      password = value;
                    },
                    decoration: kInputTextDecoration.copyWith(
                        hintText: 'Enter your password.'),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  RoundButton(
                    btnLabel: 'Log In',
                    btnColor: kLoginBtnColor,
                    onTap: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try{
                        final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
                        if(user != null){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      }catch(e){
                        setState(() {
                          showSpinner = false;
                        });
                        print(e);
                      }


                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
