import 'package:firesplit/models/Person.dart';
import 'package:firesplit/services/apicalls.dart';
import 'package:firesplit/services/databaseManager.dart';
import 'package:firesplit/views/message.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SingleChatBody extends StatefulWidget {
  SingleChatBody({Key? key, this.message, this.person, this.conversation})
      : super(key: key);

  final List<Messages>? message;
  final Person? person;
  final Map<String, dynamic>? conversation;

  @override
  _SingleChatBodyState createState() => _SingleChatBodyState();
}

class _SingleChatBodyState extends State<SingleChatBody> {
  List<Messages?> mymessage = [];
  bool isUpdated = false;
  var debt = null;
  Map<String, dynamic> conversation = new Map<String, dynamic>();
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = new ScrollController();

  var _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    mymessage = widget.message!;
    conversation = widget.conversation!;
  }

  void changeContent(text) async {
    Messages newMessage = new Messages(true, text, DateTime.now());
    addNewMessage(widget.person as Person, newMessage);

    Map<String, dynamic> myMessage = new Map<String, dynamic>();
    myMessage['message'] = text;
    myMessage['isSender'] = true;
    myMessage['time'] = DateTime.now();
    DatabaseManager().addConversation(
        conversation['userId'],
        conversation['peerId'],
        [myMessage],
        conversation['photoUrl'],
        DateTime.now());
    String checkIfPayment = text as String;
    checkIfPayment = checkIfPayment.toLowerCase();
    if (checkIfPayment.contains('owe')) {
      if (checkIfPayment.split(' ').length > 1) {
        num toOwe = num.parse(
            checkIfPayment.split(' ')[checkIfPayment.split(' ').length - 1]);
        conversation['debt'] = conversation['debt'] + toOwe;
        num debt = await DatabaseManager().updateDebt(conversation);
        print('Updated debt to ' + debt.toString());
        setState(() {
          isUpdated = true;
          debt = debt;
        });
        Fluttertoast.showToast(
            msg: 'Updated debt to ' + debt.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red.shade600,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
    if (checkIfPayment.contains('give')) {
      if (checkIfPayment.split(' ').length > 1) {
        num toGive = num.parse(
            checkIfPayment.split(' ')[checkIfPayment.split(' ').length - 1]);
        conversation['debt'] = conversation['debt'] - toGive;
        num debt = await DatabaseManager().updateDebt(conversation);
        print('Updated debt to ' + debt.toString());
        setState(() {
          isUpdated = true;
          debt = debt;
        });
        Fluttertoast.showToast(
            msg: "Updated debt to " + debt.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.green.shade700,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
    setState(() {
      mymessage.add(newMessage);
      conversation['message'].add(myMessage);
      isUpdated = false;
      debt = null;
    });

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: ListView.builder(
                itemCount: conversation['message'].length,
                controller: _scrollController,
                itemBuilder: (context, index) => Message(
                    message: conversation['message'][index]['message'],
                    isSender: conversation['message'][index]['isSender'],
                    isUpdated: isUpdated,
                    debt: debt == null ? null : debt))),
        // Spacer(),
        Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SafeArea(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                      controller: _controller,
                      decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28.0),
                          borderSide:
                              BorderSide(color: Theme.of(context).dividerColor),
                        ),
                        // icon: Icon(Icons.mic_sharp),
                        hintText: 'Send a text..',
                        hintStyle: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      autocorrect: true,
                      focusNode: _focusNode,
                      autofocus: true,
                      onFieldSubmitted: (text) {
                        if (text.isNotEmpty) {
                          changeContent(text);
                          _controller.clear();
                          _focusNode.requestFocus();
                        }
                      }),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
