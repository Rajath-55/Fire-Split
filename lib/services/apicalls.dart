import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firesplit/models/Person.dart';
import 'package:firesplit/views/message.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();
Future<Person> addPerson(Person p) async {
  CollectionReference persons =
      FirebaseFirestore.instance.collection('persons');

  Map<String, dynamic> data = p.toJson();

  final QuerySnapshot result = await FirebaseFirestore.instance
      .collection('persons')
      .where('name', isEqualTo: p.name)
      .get();
  print(result.docs.length);
  bool ans = result.docs.length > 0;

  if (ans == true) {
    return p;
  }

  await persons.add(data).then((value) => {
        p.message?.forEach((element) {
          persons.doc(value.id).collection("messages").add(element.toJson());
        })
      });

  return p;
}

Future<List<Person>> getPersons() {
  CollectionReference persons =
      FirebaseFirestore.instance.collection('persons');

  List<Person> people = [];
  return persons.get().then((querySnapshot) {
    querySnapshot.docs.forEach((element) {
      List<Map<String, dynamic>> mp = [];
      persons
          .doc(element.id)
          .collection("messages")
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          mp.add(result.data());
        });
      }).then((_) {
        // Person trial = new Person('', '', [], DateTime.now());
        // trial.fromJson(element.data() as Map<String, dynamic>, mp);
        // print(trial.message?[0].content);
        // people.add(trial);
      });

      Person temp = new Person('', '', [], DateTime.now());
      temp.fromJson(element.data() as Map<String, dynamic>, mp);
      people.add(temp);
      // print("People Length " + people.length.toString());
    });
  }).then((_) {
    return people;
  });
}

Future<List<Person>> addMessages(List<Person> persons) async {
  FirebaseFirestore.instance.collection('persons').get().then((querySnapshot) {
    querySnapshot.docs.forEach((element) {
      List<Map<String, dynamic>> mp = [];
      FirebaseFirestore.instance
          .collection('persons')
          .doc(element.id)
          .collection("messages")
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          mp.add(result.data());
        });
      }).then((_) {
        var data = element.data();
        for (int i = 0; i < persons.length; ++i) {
          if (data['name'] == persons[i].name) {
            persons[i].fromJson(data, mp);
          }
        }
        return persons;
      });
    });
  }).then((_) {});

  return [];
}

Future<bool> addNewMessage(Person person, Messages newMessage) async {
  FirebaseFirestore.instance.collection('persons').get().then((querySnapshot) {
    querySnapshot.docs.forEach((element) {
      if (element.data()['name'] == person.name) {
        FirebaseFirestore.instance
            .collection('persons')
            .doc(element.id)
            .collection("messages")
            .add(newMessage.toJson());
      }
    });
  }).then((_) {});
  return true;
}
