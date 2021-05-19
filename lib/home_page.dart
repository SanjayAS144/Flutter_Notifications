import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notifications/welcome_screen.dart';
import 'constants.dart';
import 'constants/constants.dart';
import 'package:http/http.dart';

User loggedInUser;

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
CollectionReference adminTokenRef = FirebaseFirestore.instance.collection('users');


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  final _auth = FirebaseAuth.instance;


  @override
  void initState() {
    super.initState();
    getCurrentUser();

  }
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>WelcomeScreen()));
      }
    } catch (e) {
      print(e);
    }
  }



  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Padding(
          padding:
          const EdgeInsets.only(top: 40.0, right: 20, left: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Padding(
                padding: const EdgeInsets.only(top:20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('All Users',style: headTextStyle(),),
                    GestureDetector(
                      onTap: () async {
                        await firebaseAuth.signOut();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>WelcomeScreen()));
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 10,),
                            Text('Sign Out',style:GoogleFonts.montserrat(fontSize: 16,color: Color(0xff13182A),fontWeight: FontWeight.w500),),
                            SizedBox(width: 3,)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: adminTokenRef.snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if(!snapshot.hasData){
                      return CircularProgressIndicator();
                    }
                    List<DocumentSnapshot> usersList = [];
                    snapshot.data.docs.map((e) {
                      usersList.add(e);
                    }).toList();

                    print(usersList);

                    return ListView.builder(
                      itemCount: usersList.length,
                      itemBuilder: (context, pos) {
                        return JobCard(
                          jobTitle: usersList[pos]["name"],
                          colorBg: cardColorsHome[
                          pos % cardColorsHome.length][1],
                          colorText: cardColorsHome[pos % cardColorsHome.length][0],
                          userId: usersList[pos]["uid"],
                          jobDesc: usersList[pos]["phone"],
                          date: DateFormat.yMEd().format(DateTime.parse(usersList[pos]["timestamp"])),
                          tokenId: usersList[pos]["tokenId"],

                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}

class JobCard extends StatefulWidget {
  const JobCard({
    @required this.jobTitle,
    @required this.colorBg,
    @required this.colorText,
    @required this.userId,
    @required this.jobDesc,
    @required this.date,
    @required this.tokenId,
  });

  final String jobTitle;
  final String jobDesc;
  final String userId;
  final Color colorBg;
  final Color colorText;
  final String tokenId;
  final String date;

  @override
  _JobCardState createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {


  Future<Response> sendNotification(List<String> tokenIdList, String contents, String heading) async{

    return await post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>
      {
        "app_id": kAppId,//kAppId is the App Id that one get from the OneSignal When the application is registered.

        "include_player_ids": tokenIdList,//tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

        // android_accent_color reprsent the color of the heading text in the notifiction
        "android_accent_color":"FF9976D2",

        "small_icon":"ic_stat_onesignal_default",

        "large_icon":"https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_28dp.png",

        "headings": {"en": heading},

        "contents": {"en": contents},


      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:5.0,bottom: 7),
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 8, top: 25, bottom: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: const Offset(3.0, 3.0),
                color: Colors.grey.shade500.withOpacity(0.1),
                blurRadius: 6.0,
                spreadRadius: 2.0,
              ),
              BoxShadow(
                offset: const Offset(-3.0, -3.0),
                color: Colors.white.withOpacity(0.5),
                blurRadius: 6.0,
                spreadRadius: 3.0,
              ),
            ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.jobTitle,
                  style: cardTitleTextStyle().copyWith(fontSize: 22,color: widget.colorText,),
                ),
                SizedBox(
                  height: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.date,
                        style: cardSubHeadTextStyle().copyWith(
                          color: widget.colorText.withOpacity(0.8),
                          fontSize: 14,
                        )),
                    SizedBox(
                      height: 2,
                    ),
                    Text(widget.jobDesc,
                      style: cardSubHeadTextStyle().copyWith(
                        color: widget.colorText.withOpacity(0.6),
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
              ],
            ),
            GestureDetector(
              onTap: ()=>sendNotification([widget.tokenId],"How are You","Sanjay"),
              child: Container(
                width: 70,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: cardColorsHome[0][1],
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Text("Send",style: kSendButtonTextStyle.copyWith(color: cardColorsHome[0][0]),textAlign: TextAlign.center,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

