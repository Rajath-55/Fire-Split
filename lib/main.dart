import 'package:firebase_core/firebase_core.dart';
import 'package:firesplit/screens/loginscreen.dart';
import 'package:firesplit/services/auth_block.dart';
import 'package:firesplit/services/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => AuthBlock(),
      child: MaterialApp(
        title: 'FireSplit',
        theme: Styles.themeData(true, context),
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      ),
    );
  }
}
