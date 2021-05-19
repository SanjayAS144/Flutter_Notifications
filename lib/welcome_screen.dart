import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import 'auth_screen/login_screen.dart';
import 'auth_screen/registration_screen.dart';
import 'components/round_button.dart';
import 'constants.dart';


class WelcomeScreen extends StatefulWidget {

  static String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{

  AnimationController controller;
  Animation animation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync:this,
    );

    controller.forward();
    animation = ColorTween(begin: Colors.red ,end: Colors.blue).animate(controller);
    controller.addListener(() {
      setState(() {});
      print(animation.value);
    });
  }

  // @override
  // void dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(
                  width: 250.0,
                  child: TyperAnimatedTextKit(
                    text:['Ace Steel'],
                    textStyle: TextStyle(
                      fontSize: 35.0,
                      color: Colors.black38,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundButton(btnLabel: 'Log In',btnColor: kLoginBtnColor,onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
            },),
            RoundButton(btnLabel: 'Register',btnColor: kRegisterBtnColor,onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>RegistrationScreen()));
            },),

          ],
        ),
      ),
    );
  }
}


