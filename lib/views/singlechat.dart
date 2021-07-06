import 'package:firesplit/models/Person.dart';
import 'package:firesplit/screens/chatscreen.dart';
import 'package:firesplit/views/message.dart';
import 'package:flutter/material.dart';

class SingleChatBody extends StatefulWidget {
  SingleChatBody({Key? key, this.message}) : super(key: key);

  final List<Messages>? message;

  @override
  _SingleChatBodyState createState() => _SingleChatBodyState();
}

class _SingleChatBodyState extends State<SingleChatBody> {
  List<Messages?> mymessage = [];
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = new ScrollController();

  var _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    mymessage = widget.message!;
  }

  void changeContent(text) {
    Messages newMessage = new Messages(true, text, DateTime.now());
    setState(() {
      mymessage.add(newMessage);
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
                itemCount: mymessage.length,
                controller: _scrollController,
                itemBuilder: (context, index) =>
                    Message(message: mymessage[index]))),
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
                        icon: Icon(Icons.mic_sharp),
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
                          print(mymessage.length);
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
