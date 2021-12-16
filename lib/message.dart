import 'package:flutter/material.dart';

class MenteeMessage extends StatelessWidget {
  final String text;
  MenteeMessage({required this.text});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        width: MediaQuery.of(context).size.width / 1.85,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(0),
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                topRight: Radius.circular(30)),
            color: Color(0xffC780FF)),
        child: Padding(padding: EdgeInsets.all(16), child: Text(text)),
      ),
    );
  }
}
