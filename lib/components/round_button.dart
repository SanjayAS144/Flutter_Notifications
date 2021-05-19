import 'package:flutter/material.dart';
import '../constants.dart';

class RoundButton extends StatelessWidget {

  final String btnLabel;
  final Function onTap;
  final Color btnColor;

  const RoundButton({this.btnLabel, this.onTap,this.btnColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: btnColor,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onTap,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            btnLabel,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}