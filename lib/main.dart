//import 'package:chating_hub/views/signin.dart';
import 'package:chating_hub/helper/authenticate.dart';
import 'package:chating_hub/helper/helerfunctions.dart';
import 'package:chating_hub/views/chatroomscreen.dart';
import 'package:chating_hub/views/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
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

  bool userIsLoggedIn = false;
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    getLoggedInState();
    super.initState();

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
    return MaterialApp(
      title: 'Chat Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF169b99),
        scaffoldBackgroundColor: Color(0xff1f1f1f),
        primarySwatch: Colors.blue,
      ),
      home: userIsLoggedIn != null ? /**/userIsLoggedIn ? ChatRoom() : Authenticate() /* */ : Authenticate(),
    );
  }
}
