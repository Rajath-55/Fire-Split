import 'package:firesplit/models/Person.dart';
import 'package:firesplit/services/apicalls.dart';
import 'package:uuid/uuid.dart';

class GetRandom {
  List<Person> persons = [];

  void generateChats() {
    Person one = new Person(
        Uuid().v4(),
        'Pareekshith',
        [
          new Messages(false, 'I love her dude', DateTime.now()),
          new Messages(true, 'Why suddenly this now hmm', DateTime.now()),
          new Messages(
              false, 'I cant help simping man what can I do', DateTime.now()),
          new Messages(true, 'F', DateTime.now()),
        ],
        DateTime.now());
    Person two = new Person(Uuid().v4(), 'John',
        [new Messages(false, 'Test message', DateTime.now())], DateTime.now());
    Person three = new Person(Uuid().v4(), 'Daniel',
        [new Messages(true, 'Test message', DateTime.now())], DateTime.now());
    Person four = new Person(Uuid().v4(), 'Joe',
        [new Messages(true, 'Test message', DateTime.now())], DateTime.now());
    Person five = new Person(Uuid().v4(), 'Deez',
        [new Messages(true, 'Test message', DateTime.now())], DateTime.now());

    persons.add(one);
    persons.add(two);
    persons.add(three);
    persons.add(four);
    persons.add(five);

    print(persons.length);
  }

  List<Person> sendRandom() {
    generateChats();

    for (var i = 0; i < persons.length; i++) {
      addPerson(persons[i]);
    }
    return persons;
  }
}
