import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:notifications/components/round_button.dart';
import 'package:notifications/home_page.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../constants.dart';
import '../main.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
CollectionReference adminTokenRef = FirebaseFirestore.instance.collection('users');



class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String password;
  String adminName;
  String adminPhone;
  String pin = "";

  TextEditingController textEditingController = TextEditingController();

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

  @override
  void dispose() {

    super.dispose();
  }

  void setAdminUserData() async {

    var status = await OneSignal.shared.getPermissionSubscriptionState();
    String tokenId = status.subscriptionStatus.userId;

      await adminTokenRef.doc(firebaseAuth.currentUser.uid).set({
        "uid": firebaseAuth.currentUser.uid,
        "timestamp": DateTime.now().toIso8601String(),
        "email": email,
        "name": adminName,
        "tokenId":tokenId,
        "phone": adminPhone,
      }).whenComplete(() => {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()))
      });
  }

  void createNewUser() async{
    if(email.isEmpty || password.isEmpty || adminPhone.isEmpty||adminName.isEmpty){
      final snackBar = SnackBar(content: Text('Please Fill All the Details!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }else{
      try{
        final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        if(newUser != null){
          setAdminUserData();
        }
        setState(() {
          showSpinner = false;
        });
      }catch(e){
        print(e);
        setState(() {
          showSpinner = false;
        });
      }
    }

  }


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
                    keyboardType: TextInputType.name,
                    onChanged: (value) {
                      adminName = value;
                    },
                    decoration: kInputTextDecoration.copyWith(hintText: 'Enter your Name'),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {
                      adminPhone = value;
                    },
                    decoration: kInputTextDecoration.copyWith(hintText: 'Enter user PhoneNumber'),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),




                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: kInputTextDecoration.copyWith(hintText: 'Enter your email'),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    obscureText: true,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: kInputTextDecoration.copyWith(hintText: 'Enter your password'),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  RoundButton(
                    btnLabel: 'Register',
                    btnColor: kRegisterBtnColor,
                    onTap: () async {

                      setState(() {
                        showSpinner = true;
                      });
                      createNewUser();

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



