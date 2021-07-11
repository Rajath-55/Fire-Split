import 'package:firesplit/constants/temppersons.dart';
import 'package:firesplit/models/Person.dart';
import 'package:firesplit/screens/singlechat.dart';
import 'package:firesplit/services/apicalls.dart';
import 'package:firesplit/services/databaseManager.dart';
import 'package:firesplit/views/chatcard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends StatefulWidget {
  List<Person> persons = [];
  Future<List<PayUser>>? payUsers;
  Future<List<Map<String, dynamic>>>? conversations;
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    GetRandom random = new GetRandom();
    widget.persons = random.sendRandom();
    setState(() {
      widget.conversations = callGetPersons();
    });
  }

  Future<List<Map<String, dynamic>>> callGetPersons() async {
    List<Map<String, dynamic>> convs =
        await DatabaseManager().getUserConversations();
    print('Conversations length ' + convs.length.toString());
    convs.forEach((element) {
      print('Getting');
      print(element['user']);
    });

    return convs;
  }

  @override
  Widget build(BuildContext context) {
    List<Person> persons = widget.persons;
    List<PayUser>? user = widget.payUsers as List<PayUser>?;
    return Scaffold(
      // floatingActionButton:
      //     FloatingActionButton(onPressed: () {}, child: Icon(Icons.person_add)),
      appBar: AppBar(
        leading: BackButton(onPressed: () => {Navigator.pop(context)}),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Icon(Icons.chat_bubble_rounded),
              ),
              Text('All Paymates', style: GoogleFonts.varela(fontSize: 25)),
            ])
          ],
        ),
      ),
      body: FutureBuilder(
          future: widget.conversations,
          initialData: [],
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<Map<String, dynamic>> mp =
                  snapshot.data as List<Map<String, dynamic>>;
              return (Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                          thickness: 0.8,
                        ),
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 10.0),
                          child: InkWell(
                              child: ChatCard(
                                  chat: persons[0],
                                  user: user?[0],
                                  conversation: mp[index]),
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => ChatWindow(
                                          chat: persons[index],
                                          conversation: mp[index])))),
                        ),
                        itemCount: mp.length,
                      ))
                    ],
                  ),
                ),
              ));
            } else {
              return Center(
                child: (CircularProgressIndicator()),
              );
            }
          }),
    );
  }
}
