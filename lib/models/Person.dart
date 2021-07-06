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
      'Messages': message,
      'lastMessage': lastMessage,
    };
  }
}

class Messages {
  bool? isSender;
  String? content;
  DateTime? sentTime;

  Messages(bool sender, String content, DateTime time) {
    this.isSender = sender;
    this.content = content;
    this.sentTime = time;
  }
  Map<String, dynamic> toJson() {
    return {'isSender': isSender, 'content': content, 'sentTime': sentTime};
  }
}

class Payments {
  String? recipient;
  num? amount;
}
