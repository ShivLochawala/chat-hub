import 'package:chating_hub/helper/constants.dart';
import 'package:chating_hub/services/database.dart';
import 'package:chating_hub/views/conversationscreen.dart';
import 'package:chating_hub/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController = new TextEditingController();

  QuerySnapshot searchSnapshot;

  initiateSearch(){
    databaseMethods
      .getUserByUsername(searchTextEditingController.text)
      .then((val){
        setState(() {
          searchSnapshot = val;  
        });
      });
  }
  // Create chatroom, send user to conversation screen, pushreplacement
  createChatRoomAndStartConversation(String userName){
    if(userName != null){
      String chatRoomId = getChatRoomID(userName, Constants.myName);
      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users" : users,
        "chatroomid" : chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId,chatRoomMap);
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => ConversationScreen(chatRoomId, userName)
        )
      );
    } 
  }

  Widget searchList(){
    return searchSnapshot != null ? ListView.builder(
      itemCount: searchSnapshot.docs.length,
      shrinkWrap: true,
      itemBuilder: (context, index){
        return searchTile(
          searchSnapshot.docs[index].get("name"),
          searchSnapshot.docs[index].get("email")
        );
      }
    ) : Container();
  }
  Widget searchTile(String username, String email){
    return Container(
      padding: EdgeInsets.symmetric(horizontal:24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Text(username, style: mediumTextStyle(),),
              Text(email, style: mediumTextStyle(),)
            ]
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              createChatRoomAndStartConversation(
                username
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Text("Message", style: mediumTextStyle(),),
              decoration: BoxDecoration(
                color: Color(0xFF169b99),
                borderRadius: BorderRadius.circular(30)
              ),  
            ),
          )
        ],
      )
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: Color(0xFF696969),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchTextEditingController,
                      decoration: InputDecoration(
                        hintText: "Search Username...",
                        hintStyle: TextStyle(
                          color: Colors.white54,
                          fontSize: 20.0
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    )
                  ),
                  FloatingActionButton(
                  child: Image.asset('assets/images/search_white.png',width: 25.0, height: 25.0,),
                  backgroundColor: Color(0xFF169b99),
                  onPressed: (){
                   initiateSearch();
                  },
                  )
                  //Image.asset('assets/images/search_white.png')
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}

getChatRoomID(String a, String b){
  var end = 1;
    if(a.substring(0,end).codeUnitAt(0) >= b.substring(0,end).codeUnitAt(0)){
    return "$b\_$a";
  }else{
    return "$a\_$b";
  }
}