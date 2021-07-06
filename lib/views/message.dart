import 'package:firesplit/models/Person.dart';
import 'package:firesplit/screens/chatscreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Message extends StatefulWidget {
  const Message({Key? key, this.message}) : super(key: key);

  final Messages? message;
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: widget.message!.isSender!
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Container(
              margin: EdgeInsets.only(top: 12),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                  color: Theme.of(context).hintColor,
                  borderRadius: BorderRadius.circular(30)),
              child: Text(widget.message?.content as String,
                  style: GoogleFonts.varela(fontSize: 16))),
        ),
      ],
    );
  }
}
