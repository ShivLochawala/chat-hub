import 'package:chating_hub/helper/authenticate.dart';
import 'package:chating_hub/helper/constants.dart';
import 'package:chating_hub/helper/helerfunctions.dart';
import 'package:chating_hub/services/auth.dart';
import 'package:chating_hub/services/database.dart';
import 'package:chating_hub/views/conversationscreen.dart';
import 'package:chating_hub/views/search.dart';
import 'package:chating_hub/widgets/widget.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomsStream;

  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot){
        return snapshot.hasData ? 
        ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index){
            return ChatRoomsTile(
              snapshot.data.docs[index].get("chatroomid")
              .toString().replaceAll("_", "")
              .replaceAll(Constants.myName, ""),
              snapshot.data.docs[index].get("chatroomid")
            );
          }
        )
        : Container();
      }
    );
  }

  getUserInfo() async{
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    Constants.myEmail = await HelperFunctions.getUserEmailSharedPreference();
     databaseMethods.getChatRooms(Constants.myName).then((value){
      setState(() {
        chatRoomsStream = value;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Image.asset("assets/images/logo.png", height: 50.0),
        actions: [
          GestureDetector(
            onTap: (){
              authMethods.signOut();
              HelperFunctions.saveUserLoggedInSharedPreference(false);
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context)=>Authenticate(),
                )
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal:16),
              child: Icon(Icons.logout),
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Container(
                padding: EdgeInsets.only(top:50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(Constants.myName, style: mediumTextStyle(),),
                    Text(Constants.myEmail, style: mediumTextStyle(),)
                  ],
                ),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors:[
                    const Color(0xFF169b99),
                    const Color(0xFF24a19f)
                  ] 
                ), 
              ),
            ),
            ListTile(
              title: Text('Settings',
                style: TextStyle(
                  fontSize: 20.0
                  ),
                ),
              leading: Icon(Icons.settings),
              onTap: () {
              },
            ),
            ListTile(
              title: Text('LogOut',
                style: TextStyle(
                  fontSize: 20.0
                  ),
                ),
              leading: Icon(Icons.logout),
              onTap: () {
                authMethods.signOut();
                HelperFunctions.saveUserLoggedInSharedPreference(false);
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context)=>Authenticate(),
                  )
                );
              },
            ),
          ],
          
        ),
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        backgroundColor: Color(0xFF169b99),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => SearchScreen()
            )
          );
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String otherUserName;
  final String chatRoom;
  ChatRoomsTile(this.otherUserName, this.chatRoom);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context)=> ConversationScreen(chatRoom, otherUserName),
          )
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical:16, horizontal: 24),
        color: Colors.black,
        child:Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xFF008280),
                borderRadius: BorderRadius.circular(40)
              ),
              child: Text("${otherUserName.substring(0,1).toUpperCase()}", style: mediumTextStyle(),),
            ),
            SizedBox(width: 8),
            Text(otherUserName, style: mediumTextStyle(),)
          ],
        )
      ),
    );
  }
}