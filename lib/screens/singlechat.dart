import 'package:firesplit/models/Person.dart';
import 'package:firesplit/views/singlechat.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatWindow extends StatefulWidget {
  final Person? chat;
  final Map<String, dynamic>? conversation;
  const ChatWindow({Key? key, this.chat, this.conversation}) : super(key: key);

  @override
  _ChatWindowState createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.red.shade300,
          leading: BackButton(onPressed: () => {Navigator.pop(context)}),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(children: [
                Padding(
                  padding: const EdgeInsets.only(right: 7.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        widget.conversation?['photoUrl'] as String),
                    radius: 24,
                  ),
                ),
                Text(widget.conversation?['peer'] as String,
                    style: GoogleFonts.montserrat(fontSize: 25)),
              ])
            ],
          ),
        ),
        body: SingleChatBody(
            message: widget.chat?.message,
            person: widget.chat,
            conversation: widget.conversation));
  }
}
