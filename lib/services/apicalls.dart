import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firesplit/models/Person.dart';
import 'package:firesplit/screens/chatscreen.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();
Future<Person> addPerson(Person p) async {
  CollectionReference persons =
      FirebaseFirestore.instance.collection('persons');

  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser!.uid.toString();
  String? name = auth.currentUser!.displayName;
  Map<String, dynamic> data = p.toJson();

  await persons.add(data);
  return p;
}

Future<List<Person>> getPersons() async {
  CollectionReference persons =
      FirebaseFirestore.instance.collection('persons');

  FirebaseAuth auth = FirebaseAuth.instance;
  await persons.get();
  return [];
}
