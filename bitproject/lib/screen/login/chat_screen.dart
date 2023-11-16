import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  static String id = "chat_screen";

  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  late String messageText;

  String nickname = '';

  late final userInfo = <String, dynamic>{
    "nickname": nickname,
  };

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        _firestore
            .collection("userinfo")
            .doc(loggedInUser.email)
            .get()
            .then((value) => userInfo["nickname"] = value.data()?["nickname"]);
        print(userInfo["nickname"]);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        foregroundColor: Colors.black87,
        leading: null,
        title: const Text(
          '채팅방',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        backgroundColor: Colors.yellow[600],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder(
              stream: _firestore
                  .collection('messages')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  final message = snapshot.data?.docs;
                  List<MessageBubble> messages = [];
                  for (var msg in message!) {
                    final msgTime = (msg.data())['msgTime'];
                    final messageTxt = (msg.data())['text'];
                    final messageSender = (msg.data())['sender'];
                    final sender = (msg.data())['nickname'];
                    final currentUser = loggedInUser.email;
                    messages.add(MessageBubble(
                        msgTime: msgTime,
                        messageTxt: messageTxt,
                        messageSender: sender,
                        isMe: currentUser == messageSender));
                  }
                  return Expanded(
                      child: ListView(reverse: true, children: messages));
                }
              },
            ),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.7),
                    blurRadius: 5.0,
                    spreadRadius: 7.0,
                    offset: const Offset(0, 7),
                  )
                ],
                color: Colors.white,
                shape: BoxShape.rectangle,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.chat,
                      color: Colors.yellow[900],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8, left: 10),
                      child: TextField(
                        cursorColor: Colors.grey[800],
                        maxLines: 6,
                        minLines: 1,
                        keyboardType: TextInputType.multiline,
                        controller: messageTextController,
                        onChanged: (value) {
                          messageText = value;
                        },
                        decoration: const InputDecoration(
                          hintText: "메세지를 입력해주세요.",
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      _firestore.collection('messages').add(
                        {
                          'msgTime': DateFormat('aa hh:mm')
                              .format(DateTime.now())
                              .toString(),
                          'text': messageText,
                          'sender': loggedInUser.email,
                          'nickname': userInfo['nickname'],
                          'createdAt': DateTime.now(),
                        },
                      );
                    },
                    child: Icon(
                      Icons.send_rounded,
                      color: Colors.yellow[900],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String messageTxt;
  final String messageSender;
  final String msgTime;
  final bool isMe;

  const MessageBubble({
    Key? key,
    required this.messageTxt,
    required this.messageSender,
    required this.isMe,
    required this.msgTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Text(
            messageSender,
            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Text(
            "$msgTime ",
            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.only(
                topLeft: isMe
                    ? const Radius.circular(30.0)
                    : const Radius.circular(0),
                bottomLeft: const Radius.circular(30.0),
                bottomRight: const Radius.circular(30.0),
                topRight: isMe
                    ? const Radius.circular(0)
                    : const Radius.circular(30)),
            color: isMe ? Colors.yellow[600] : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                messageTxt,
                style: TextStyle(
                    color: isMe ? Colors.black87 : Colors.black54,
                    fontSize: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
