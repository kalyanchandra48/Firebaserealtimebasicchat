import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class Message {
  final String text;
  final DateTime date;

  Message({required this.text, required this.date});
  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source));

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'date': date.toString(),
        'text': text,
      };
  factory Message.fromMap(Map<String, dynamic> map) {
    return new Message(text: map['text'], date: map['date']);
  }
}
