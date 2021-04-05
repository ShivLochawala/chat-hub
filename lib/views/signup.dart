import 'package:chating_hub/helper/helerfunctions.dart';
import 'package:chating_hub/services/auth.dart';
import 'package:chating_hub/services/database.dart';
import 'package:chating_hub/views/chatroomscreen.dart';
import 'package:chating_hub/widgets/widget.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  signMeUp(){
    if(formKey.currentState.validate()){
      Map<String, dynamic> userInfoMap={
        "name" : userNameTextEditingController.text,
        "email" : emailTextEditingController.text
      };
      HelperFunctions.saveUserNameSharedPreference(userNameTextEditingController.text);
      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);

      setState(() {
        isLoading = true;
      });
      authMethods.signUpWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((value){
        //print("${value.uid}");
         
        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ChatRoom())
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        )
      ): SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 150,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children:[
                Text("Sign Up", style: TextStyle(fontSize: 30, color: Colors.white),),
                Form(
                  key: formKey,
                  child: Column(
                    children:[
                      TextFormField(
                        validator: (val){
                          if(val.isEmpty){
                            return "Username can't be empty";
                          }
                        },
                        controller: userNameTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration("Username"),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        validator: (val){

                          if(val.isEmpty){
                            return "Email can't be empty";
                          }else if(!RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(val)){
                            return "Invalid Email Id";
                          }
                        },
                        controller: emailTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration("Email"),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        obscureText: true,
                        validator: (val){
                          if(val.isEmpty){
                            return "Password can't be empty";
                          }else if(val.length < 6){
                            return "Password Should be 6 Digit";
                          }
                        },
                      
                        controller: passwordTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration("Password"),
                      ),
                    ]
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: (){
                    signMeUp();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical:20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF169b99),
                          const Color(0xFF24a19f)
                        ]
                      ),
                      borderRadius: BorderRadius.circular(30) 
                    ),
                    child: Text("Sign Up", style: mediumTextStyle()),
                  ),
                ),
                SizedBox(height: 16),
                /*
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)
                  ),
                  child: Text("Sign Up with google", 
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17
                    ),
                  ),
                ),
                SizedBox(height: 16),*/
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Text("Already Sign In? ", style: mediumTextStyle(),),
                    GestureDetector(
                      onTap: (){
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical:8),
                        child: Text("SignIn now", 
                          style:TextStyle(
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
              ]
            ),
          ),
        ),
      )
    );
  }
}