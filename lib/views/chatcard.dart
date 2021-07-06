import 'package:firesplit/models/Person.dart';
import 'package:firesplit/screens/chatscreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    this.chat,
  });
  final Person? chat;

  @override
  Widget build(BuildContext context) {
    // String? text = chat.message?[chat.message.length - 1];
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(right: 8.0, bottom: 2.0),
        child: CircleAvatar(
          backgroundImage: AssetImage('assets/images/loginimage.png'),
          radius: 24,
        ),
      ),
      Expanded(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(chat?.name as String,
                  style: GoogleFonts.sourceSansPro(fontSize: 16)),
              Text(DateFormat('hh:mm a').format(chat?.lastMessage as DateTime)),
            ],
          ),
          Text(
            chat!.message!.elementAt(chat!.message!.length - 1).content
                as String,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ))
    ]);
  }
}
