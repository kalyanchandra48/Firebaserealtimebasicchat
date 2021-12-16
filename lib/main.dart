import 'package:flutter/material.dart';
import 'message.dart';
import 'models/firemessage.dart';
import 'services/dbreference.dart';
import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HiveApp(),
    ),
  );
}

class HiveApp extends StatefulWidget {
  @override
  _HiveAppState createState() => _HiveAppState();
}

class _HiveAppState extends State<HiveApp> {
  final ScrollController _scrollController = ScrollController();
  void scrolltoBottom() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 50), curve: Curves.fastOutSlowIn);
  }

  List<String> message = [];
  final _firebaseRef = FirebaseDatabase().reference().child('messages');
  final messageController = TextEditingController();
  late Stream messages;
  initState() {
    super.initState();
    this.messages = _firebaseRef.orderByChild('messages').onValue;
    _firebaseRef.orderByChild('messages').once().then((v) {
      final val = (v.snapshot.value) ?? {};
      print(val);
      final w = Map<String, dynamic>.from(json.decode(json.encode(val)));
      w.entries.forEach((v) {
        message.add(v.value["text"]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        left: true,
        right: true,
        child: Column(
          children: [
            StreamBuilder(
              stream: this.messages,
              builder: (BuildContext context, streamSnapshot) {
                return Expanded(
                  child: ListView.separated(
                      controller: _scrollController,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      padding: EdgeInsets.only(top: 10, right: 15),
                      itemCount: message.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 10,
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return MenteeMessage(text: message[index]);
                        ;
                      }),
                );
              },
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 52,
                  width: MediaQuery.of(context).size.width / 1.45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color(0xffF2F2F2)),
                  child: TextField(
                    textInputAction: TextInputAction.go,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: messageController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Type a Message...',
                      contentPadding: EdgeInsets.all(15),
                    ),
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      if (messageController.text != '') {
                        final messageOne = Message(
                          text: messageController.text,
                          date: DateTime.now(),
                        );
                        MessageDao().saveMessage(messageOne);

                        setState(() {
                          //   scrolltoBottom();
                          message.add(messageController.text);
                          messageController.clear();
                        });
                      }
                    },
                    child: Icon(Icons.near_me_outlined, size: 45)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
