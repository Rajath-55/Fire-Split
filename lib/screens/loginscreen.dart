import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firesplit/screens/homescreen.dart';
import 'package:firesplit/services/auth_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late StreamSubscription<User?> _loginStateSubscription;

  @override
  void initState() {
    super.initState();
    var authBlock = Provider.of<AuthBlock>(context, listen: false);
    _loginStateSubscription = authBlock.currentUser.listen((isuser) {
      if (isuser != null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _loginStateSubscription.cancel();
  }

  Widget build(BuildContext context) {
    final authBlock = Provider.of<AuthBlock>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 6),
            Spacer(flex: 1),
            Container(
              padding: EdgeInsets.all(14),
              margin: EdgeInsets.all(10),
              child: Text(
                  'FireSplit. All your expenses, taken care of in one go.',
                  style: GoogleFonts.montserrat(fontSize: 28)),
            ),
            Container(
              margin: EdgeInsets.all(15.0),
              padding: EdgeInsets.symmetric(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2.5),
                child: Image.asset('assets/images/loginimage.png',
                    width: 300, height: 200),
              ),
            ),
            Spacer(flex: 2),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Sign up. It's free.",
                      style: GoogleFonts.montserrat(
                          textStyle: TextStyle(fontWeight: FontWeight.w400))),
                  Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ElevatedButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: Icon(
                                  Icons.logout,
                                ),
                              ),
                              Text("Login With Google".toUpperCase(),
                                  style: TextStyle(fontSize: 14)),
                            ],
                          ),
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(15)),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.green.shade600),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                      side: BorderSide(
                                          color: Colors.green.shade600)))),
                          onPressed: () => authBlock.loginGoogle())),
                ],
              ),
            ),
            Spacer(flex: 3),
            SizedBox(height: MediaQuery.of(context).size.height / 6),
          ],
        ),
      ),
    );
  }
}
