import 'package:chating_hub/helper/helerfunctions.dart';
import 'package:chating_hub/services/auth.dart';
import 'package:chating_hub/services/database.dart';
import 'package:chating_hub/views/chatroomscreen.dart';
import 'package:chating_hub/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  bool isLoading = false;
  final keys = GlobalKey<FormState>();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  QuerySnapshot snapshotUserInfo;

  signMeIn(){
    if(keys.currentState.validate()){
      
      setState(() {
        isLoading = true;
      });

      authMethods.signInWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((value){
        if(value != null){
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          databaseMethods.getUserByUserEmail(emailTextEditingController.text).then((value){
            snapshotUserInfo = value;
            HelperFunctions.saveUserEmailSharedPreference(snapshotUserInfo.docs[0].get("email"));
            HelperFunctions.saveUserNameSharedPreference(snapshotUserInfo.docs[0].get("name"));
            print(snapshotUserInfo.docs[0].get("name"));
          });
          Navigator.pushReplacement(context,       MaterialPageRoute(
            builder: (context) => ChatRoom()
            )
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading? Container(
        child: Center(
          child: CircularProgressIndicator(),
          ),
        ) :SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.bottomCenter,
          child:  Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children:[
                Text("Sign In", style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),),
                SizedBox(height: 8),
                Form(
                  key: keys,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val){
                          if(val.isEmpty){
                              return "Email can't be empty";
                          }else if(!RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(val)){
                            return "Invalid Email Id";
                          }
                          return null;
                        },
                        controller: emailTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration("Email"),
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (val){
                          if(val.isEmpty){
                            return "Password can't be empty";
                          }
                          return null;
                        },
                        controller: passwordTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration("Password"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  alignment: Alignment.centerRight,
                  child:  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text('Forgot Password?', 
                      style: simpleTextStyle(),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: (){
                    signMeIn();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      gradient:  LinearGradient(
                        colors:[
                          const Color(0xFF169b99),
                          const Color(0xFF24a19f)
                        ] 
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text("Sign In", style: mediumTextStyle(),), 
                  ),
                ),
                SizedBox(height:16),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)
                  ),
                  child: Text("Sign In with Google", 
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                    ),
                  ),
                ),
                SizedBox(height:16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don\'t have account? ", style: mediumTextStyle(),),
                    GestureDetector(
                      onTap: (){
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical:8),
                        child: Text("Register now", 
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            decoration: TextDecoration.underline
                          ),
                        ),
                      ),
                    )
                  ]
                ),
                SizedBox(height: 50)
              ],
            ),
          ),
        ),
      )
    );
  }
}