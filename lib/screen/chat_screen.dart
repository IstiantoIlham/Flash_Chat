import 'package:chat_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class ChatScreen extends StatefulWidget{
  static const String id = 'CHAT_SCREEN';
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final fieldText = TextEditingController();

  late String messageText;
  late DateTime now;
  late String formattedDate;

  void getCurrentUser() async {
    try{
      final user = _auth.currentUser!;
      loggedInUser = user;
      print(loggedInUser.email);
    }catch (e){
      /// Masih kosong
    }
}

@override
void initState() {
    super.initState();
    getCurrentUser();

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: const Icon(Icons.forum),
        actions: [
          IconButton(
            onPressed: (){
              _auth.signOut();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.logout)),
        ],
        title: const Text('Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: TextField(
                controller: fieldText,
                onChanged: (value){
                  messageText = value;
                },
                decoration: kMessageTextFieldDecoration,
              ),
            ),
            TextButton(
              onPressed: (){
                var newMessage = messageText;
                messageText = '';
                if (newMessage.isEmpty || newMessage.trim().isEmpty)return;
                setState(() {
                  now = DateTime.now();
                  formattedDate = DateFormat('kk:mm:ss').format(now);
                });
                _firestore.collection
                  ('messages').add({
                  'sender' : loggedInUser.email,
                  'text' : newMessage,
                  'time' : formattedDate,});
                fieldText.clear();
            },
              child: const Text('Sent',
              style: kSendButtonTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class MessageStream extends StatelessWidget {
  const MessageStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlue,
            ),
          );
        }
        final messages = snapshot.data!.docs;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message['text'];
          final messageSender = message['sender'];

          final currentUserMail = loggedInUser.email;

          final messageBubble = MessageBubble(
            sender : messageSender,
            text : messageText,
            isMe : currentUserMail == messageSender
          );
          messageBubbles.add(messageBubble);

        }
        return Expanded(child: ListView(
          reverse: true,
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          children: messageBubbles,
        ));
      }
    );
  }
}


class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;

  const MessageBubble(
      {Key? key, required this.sender, required this.text, required this.isMe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(8.0),
    child: Column(crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
    children: [
      Text(
        sender,
        style: const TextStyle(color: Colors.black54, fontSize: 12.0),),
      Material(
        borderRadius: BorderRadius.only(
          topLeft:
            isMe ? const Radius.circular(30.0) : const Radius.circular(0.0),
          topRight: isMe ? const Radius.circular(0.0) : const Radius.circular(30.0),
          bottomLeft: const Radius.circular(30.0),
          bottomRight: const Radius.circular(30.0)),

        elevation: 5.0,
        color: isMe ? Colors.lightBlue : Colors.white,
        child: Padding(
          padding : const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Text(
              text,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
                fontSize: 15.0
               ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

