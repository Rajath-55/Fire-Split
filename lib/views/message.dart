import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Message extends StatefulWidget {
  Message({Key? key, this.message, this.isSender, this.isUpdated, this.debt})
      : super(key: key);

  final String? message;
  final bool? isSender;
  final bool? isUpdated;
  num? debt;
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.45, horizontal: 4.25),
      child: BubbleNormal(
        text: widget.message as String,
        textStyle: TextStyle(fontWeight: FontWeight.w400),
        isSender: widget.isSender!,
        color: Color.fromRGBO(180, 144, 144, 0.35),
        tail: true,
        sent: widget.isSender!,
        delivered: widget.isSender!,
      ),
    );
  }
}
