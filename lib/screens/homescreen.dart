import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firesplit/screens/chatscreen.dart';
import 'package:firesplit/screens/loginscreen.dart';
import 'package:firesplit/screens/paymentscreen.dart';
import 'package:firesplit/services/apicalls.dart';
import 'package:firesplit/services/auth_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription<User?> _loginStateSubscription;

  @override
  void initState() {
    super.initState();
    print("Init");
    getPersons();

    var authBlock = Provider.of<AuthBlock>(context, listen: false);
    _loginStateSubscription = authBlock.currentUser.listen((isuser) {
      print("Listening");
      if (isuser == null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _loginStateSubscription.cancel();
  }

  Widget build(BuildContext context) {
    final authBlock = AuthBlock();
    return Scaffold(
        body: Center(
            child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<User?>(
          stream: authBlock.currentUser,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Column(
                      children: [
                        Text(snapshot.data?.displayName as String,
                            style: GoogleFonts.varela(fontSize: 32)),
                        // SizedBox(height: 20.0),
                        Container(
                          margin: EdgeInsets.all(25),
                          child: CircleAvatar(
                            radius: 65.0,
                            backgroundImage:
                                NetworkImage(snapshot.data?.photoURL as String),
                          ),
                        ),
                        // SizedBox(height: 20.0),
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Text(
                            'This is FireSplit. Efficiently split all your money in one go.',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 4.0),
                                          child: Icon(
                                            Icons.payments,
                                          ),
                                        ),
                                        Text("My Payments".toUpperCase(),
                                            style: TextStyle(fontSize: 14)),
                                      ],
                                    ),
                                    style: ButtonStyle(
                                        padding:
                                            MaterialStateProperty.all<EdgeInsets>(
                                                EdgeInsets.all(15)),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Theme.of(context).buttonColor),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                                side: BorderSide(
                                                    color: Colors.red)))),
                                    onPressed: () => Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (context) => PaymentScreen()))),
                                SizedBox(width: 10),
                                ElevatedButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 4.0),
                                          child: Icon(
                                            Icons.chat_bubble,
                                          ),
                                        ),
                                        Text("ChatPay".toUpperCase(),
                                            style: TextStyle(fontSize: 14)),
                                      ],
                                    ),
                                    style: ButtonStyle(
                                        padding:
                                            MaterialStateProperty.all<EdgeInsets>(
                                                EdgeInsets.all(15)),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Theme.of(context).buttonColor),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                                side: BorderSide(
                                                    color: Colors.red)))),
                                    onPressed: () => Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (context) => ChatScreen()))),
                              ]),
                        )
                        // SizedBox(height: 80.0),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SizedBox(width: 20),
                        ElevatedButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Icon(
                                    Icons.logout,
                                  ),
                                ),
                                Text("Signout".toUpperCase(),
                                    style: TextStyle(fontSize: 14)),
                              ],
                            ),
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.all(15)),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.green.shade500),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: BorderSide(
                                            color: Colors.green.shade500)))),
                            onPressed: () => authBlock.logout()),
                      ],
                    ),
                  ],
                ),
              );
            }
          }),
    )));
  }
}
