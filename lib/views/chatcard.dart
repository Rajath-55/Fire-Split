import 'package:firesplit/models/Person.dart';
import 'package:firesplit/services/databaseManager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({this.chat, this.user});
  final Person? chat;
  final PayUser? user;

  @override
  Widget build(BuildContext context) {
    if (chat?.message?.length == 0) {
      chat?.message = [
        new Messages(false, 'Just for the lulz', DateTime.now())
      ];
    }
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(right: 8.0, bottom: 2.0),
        child: CircleAvatar(
          backgroundImage: NetworkImage(user?.photoUrl as String),
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
              Text(DateFormat('hh:mm a').format(user
                  ?.conversations[user!.conversations.length - 1]
                  .messageTime as DateTime)),
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
