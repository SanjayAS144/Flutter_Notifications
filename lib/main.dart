import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notifications/auth_screen/login_screen.dart';
import 'package:notifications/constants.dart';
import 'package:notifications/home_page.dart';
import 'package:notifications/welcome_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    configOneSignel();
  }

  void configOneSignel()
  {
    OneSignal.shared.init(kAppId);
  }




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}


class SendNotificationButton extends StatelessWidget {

  final Function sendNotification;

  const SendNotificationButton({this.sendNotification});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: MaterialButton(
        onPressed: sendNotification
        ,
        child: Text("Send",style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.w600),),
        height: 50,
        padding: EdgeInsets.all(10),
        color: Colors.blue,
        minWidth: double.infinity,
      ),
    );
  }
}



