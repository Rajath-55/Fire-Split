import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseManager {
  late final String currentUserID;
  final CollectionReference userList =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference messages =
      FirebaseFirestore.instance.collection('conversations');
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> createNewUser() async {
    User? user = auth.currentUser;
    getAllUsers();
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: user?.uid)
        .get();
    if (result.docs.length > 0) {
      Map<String, dynamic> curr = result.docs[0].data() as Map<String, dynamic>;
      currentUserID = curr['uid'];
      return;
    }
    Map<String, dynamic> userData = Map<String, dynamic>();
    userData['displayName'] = user?.displayName;
    userData['email'] = user?.email;
    userData['photoUrl'] = user?.photoURL;
    userData['uid'] = user?.uid;
    userList.add(userData).then((value) => print(value));
  }

  Future<List<PayUser>> getAllUsers() async {
    bool flag = true;
    final QuerySnapshot result = await userList.get();
    List<PayUser> res = [];
    print(result.docs.length);
    result.docs.forEach((element) {
      Map<String, dynamic> elementData = element.data() as Map<String, dynamic>;

      res.add(new PayUser(elementData['uid'], elementData['photoUrl'],
          elementData['displayName'], elementData['email']));
    });
    // test
    addConversation(
        res[1].uid,
        res[2].uid,
        ["Hi", "This is a test", "This is me tryna test messages"],
        DateTime.now());

    return res;
  }

  Future<List<Conversation>> getAllConversations() async {
    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('conversations').get();
    List<Conversation> res = [];
    result.docs.forEach((element) {
      Map<String, dynamic> elementData = element.data() as Map<String, dynamic>;
      res.add(new Conversation(
          elementData['peer'],
          elementData['peerId'],
          elementData['userId'],
          elementData['conversationId'],
          elementData['user'],
          elementData['message'],
          elementData['messageTime'].toDate(),
          elementData['debt']));
    });
    return res;
  }

  // Future<List<Conversation>> currentUserConvos() async {
  //   final QuerySnapshot result = await FirebaseFirestore.instance
  //       .collection('conversations')
  //       .where('userId', isEqualTo: currentUserID)
  //       .get();
  //   if (result.docs.length == 0) return [];
  //   Map<String, dynamic> data = result.docs[0].data() as Map<String, dynamic>;

  // }

  Future<List<PayUser>> appendConversations(List<PayUser> peeps) async {
    final List<Conversation> allConvos = await getAllConversations();
    // print("All Convos size : " + allConvos.length.toString());
    Map<PayUser, List<Conversation>> mp =
        new Map<PayUser, List<Conversation>>();

    for (int i = 0; i < peeps.length; ++i) {
      mp[peeps[i]] = [];
    }
    for (int i = 0; i < allConvos.length; ++i) {
      for (int j = 0; j < peeps.length; ++j) {
        if (peeps[j].uid == allConvos[i].userId) {
          mp[peeps[j]]?.add(allConvos[i]);
        }
      }
    }
    for (int i = 0; i < peeps.length; i++) {
      peeps[i].addConversations(mp[peeps[i]] as List<Conversation>);
    }
    return peeps;
  }

  Future<void> addConversation(String userId, String peerId,
      List<String> messages, DateTime time) async {
    String convId = getConversationID(userId, peerId);
    CollectionReference conv =
        FirebaseFirestore.instance.collection('conversations');

    bool flag = true;

    final QuerySnapshot res =
        await conv.where('conversationId', isEqualTo: convId).get();
    if (res.docs.length > 0) {
      flag = false;
    }
    Map<String, dynamic> convData = Map<String, dynamic>();
    convData['conversationId'] = convId;
    convData['userId'] = userId;
    convData['peerId'] = peerId;
    convData['debt'] = 0;
    final QuerySnapshot userResult =
        await userList.where('uid', isEqualTo: userId).limit(1).get();
    final QuerySnapshot peerResult =
        await userList.where('uid', isEqualTo: peerId).limit(1).get();
    Map<String, dynamic> data =
        userResult.docs[0].data() as Map<String, dynamic>;
    Map<String, dynamic> peerData =
        peerResult.docs[0].data() as Map<String, dynamic>;

    convData['user'] = data['displayName'];
    convData['peer'] = peerData['displayName'];
    convData['message'] = [];
    messages.forEach((element) {
      convData['message'].add(element);
    });
    convData['messageTime'] = time;

    if (flag == true) {
      dynamic res = await conv.add(convData);
    }
    return;
  }

  String getConversationID(String userID, String peerID) {
    return userID.hashCode <= peerID.hashCode
        ? userID + '_' + peerID
        : peerID + '_' + userID;
  }
}

class PayUser {
  late String uid;
  late String name;
  late String email;
  late String photoUrl;
  late List<Conversation> conversations;

  PayUser(
    String uid,
    String photoUrl,
    String name,
    String email,
  ) {
    this.uid = uid;
    this.name = name;
    this.photoUrl = photoUrl;
    this.email = email;
    this.conversations = [];
  }
  void addConversations(List<Conversation> conversations) {
    this.conversations = conversations;
  }
}

class Conversation {
  late String peer;
  late String peerId;
  late String userId;
  late String convId;
  late String user;
  late List<dynamic> messages;
  late DateTime messageTime;
  late num debt;

  Conversation(String peer, String peerId, String userId, String convId,
      String user, List<dynamic> messages, DateTime messageTime, num debt) {
    this.peer = peer;
    this.peerId = peerId;
    this.userId = userId;
    this.convId = convId;
    this.user = user;
    this.messages = [];
    this.messages = messages;
    this.messageTime = messageTime;
    this.debt = debt;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> res = new Map<String, dynamic>();
    res['peer'] = this.peer;
    res['user'] = this.user;
    res['message'] = [];
    messages.forEach((message) => res['message'].add(message));
    res['messageTime'] = this.messageTime;
    res['debt'] = this.debt;
    res['peerId'] = this.peerId;
    res['userId'] = this.userId;
    res['convId'] = this.convId;
    return res;
  }
}
