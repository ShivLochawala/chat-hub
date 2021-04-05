import 'package:chating_hub/helper/constants.dart';
import 'package:chating_hub/services/database.dart';
import 'package:chating_hub/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  final String otherUsername;
  ConversationScreen(this.chatRoomId, this.otherUsername);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageTextEditingController = new TextEditingController();
  
  Stream chatMessageStrem; 

  Widget ChatMessageList(){
    return StreamBuilder(
      stream: chatMessageStrem,
      builder: (context, snapshot){
       return snapshot.hasData? ListView.builder(
         itemCount: snapshot.data.docs.length,
         itemBuilder: (context, index){
           return MessageTile(snapshot.data.docs[index].get("message"), snapshot.data.docs[index].get("sendby") == Constants.myName);
         }
        ):Container(); 
      },
    );
  }
  
  sendMessage(){
    if(messageTextEditingController.text.isNotEmpty){
      Map<String, dynamic> messageMap = {
      "message" : messageTextEditingController.text,
      "sendby" : Constants.myName,
      "time" : DateTime.now().microsecondsSinceEpoch,
      }; 
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageTextEditingController.text = "";
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value){
      setState(() {
        chatMessageStrem = value;  
      });
      
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.otherUsername.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 25.0),),),
      body: Container(
        child: Stack(
          children: [
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                color: Color(0xFF696969),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageTextEditingController,
                        decoration: InputDecoration(
                          hintText: "Message...",
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
                      child: Image.asset('assets/images/send.png',width: 25.0, height: 25.0,),
                      backgroundColor: Color(0xFF169b99),
                      onPressed: (){
                      sendMessage();
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal:24, vertical:16),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal:24, vertical:16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe ?[
              const Color(0xFF008280),
              const Color(0xFF39bebc)
            ]:[
              const Color(0x1AFFFFFF),
              const Color(0x1AFFFFFF)
            ] 
          ),
          borderRadius: isSendByMe ? BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomLeft: Radius.circular(23)
          ): BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomRight: Radius.circular(23)
          )
        ),
        child: Text(message, style:TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}