import 'package:firebase_database/firebase_database.dart';
import '../models/firemessage.dart';

class MessageDao {
  void saveMessage(Message message) {
    _messagesRef.push().set(message.toJson());
  }

  Query getMessageQuery() {
    return _messagesRef;
  }

  final DatabaseReference _messagesRef =
      FirebaseDatabase.instance.reference().child('messages');
}
