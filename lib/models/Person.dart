import 'package:uuid/uuid.dart';

class Person {
  String? id;
  String? name;
  List<Messages>? message;
  DateTime? lastMessage;
  late List<Payments?> payments;

  Person(String id, String name, List<Messages> message, DateTime lastMessage) {
    this.id = id;
    this.name = name;
    this.message = message;
    this.lastMessage = lastMessage;
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastMessage': lastMessage,
    };
  }

  Person fromJson(
      Map<String, dynamic> personObj, List<Map<String, dynamic>> messageObj) {
    id = personObj['id'];
    name = personObj['name'];
    lastMessage = personObj['lastMessage'].toDate();
    message = Messages(false, '', DateTime.now()).fromJson(messageObj);
    // print(name);
    return Person(id as String, name as String, message as List<Messages>,
        lastMessage as DateTime);
  }
}

class Messages {
  bool? isSender;
  String? content;
  DateTime? sentTime;
  String? id;

  Messages(bool sender, String content, DateTime time) {
    id = Uuid().v4();
    this.isSender = sender;
    this.content = content;
    this.sentTime = time;
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isSender': isSender,
      'content': content,
      'sentTime': sentTime
    };
  }

  List<Messages>? fromJson(List<Map<String, dynamic>> messagesObj) {
    List<Messages> ans = [];
    if (messagesObj.length == 0) {
      Messages temp =
          new Messages(true, 'No messages with recipient!', DateTime.now());
      ans.add(temp);
      return ans;
    }
    messagesObj.forEach((element) {
      Messages temp = new Messages(false, '', DateTime.now());
      temp.id = element['id'];
      temp.isSender = element['isSender'];
      temp.content = element['content'];
      temp.sentTime = element['sentTime'].toDate();
      ans.add(temp);
    });
    return ans;
  }
}

class Payments {
  String? recipient;
  num? amount;
}
