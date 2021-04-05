import 'dart:async';
import 'package:flutter/material.dart';
import 'package:chating_hub/helper/authenticate.dart';
import 'package:chating_hub/helper/helerfunctions.dart';
import 'package:chating_hub/views/chatroomscreen.dart';

class SplashSceen extends StatefulWidget {
  @override
  _SplashSceenState createState() => _SplashSceenState();
}

class _SplashSceenState extends State<SplashSceen> {
  bool userIsLoggedIn = false;
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    getLoggedInState();
    super.initState();
     Timer(
      Duration(seconds: 3), (){
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => userIsLoggedIn != null ? /**/userIsLoggedIn ? ChatRoom() : Authenticate() /* */ : Authenticate(),
          )
        );
      } 
    );
  }

  getLoggedInState() async{
    await HelperFunctions.getUserLoggedInSharedPreference().then((value){
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF008280),
      child:Image.asset('assets/images/logo.png',width: 80.0, height: 40),
    );
  }
}