import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseManager {
  String currentUserID = '';
  static bool madeNewConversations = false;
  final CollectionReference userList =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference messages =
      FirebaseFirestore.instance.collection('conversations');
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> createNewUser() async {
    User? user = auth.currentUser;
    currentUserID = user?.uid as String;
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
    //Add fresh conversations for everyone other than the current user.
    currentUserID = auth.currentUser!.uid;
    if (madeNewConversations == false) {
      for (int i = 0; i < res.length; ++i) {
        print("IN this loop");
        if (res[i].uid != currentUserID) {
          List<Map<String, dynamic>> messages = [];
          messages.add({
            'time': DateTime.now(),
            'isSender': true,
            'message': 'Hello, and welcome to fireSplit Chat!'
          });
          messages.add({
            'time': DateTime.now(),
            'isSender': false,
            'message':
                'Here, you can add into your payment coffers, or take out of them with the person you are conversing!'
          });
          messages.add({
            'time': DateTime.now(),
            'isSender': true,
            'message':
                'Just type the words : Owe x, or Give x, to either add into your debt or remove amounts from it!'
          });
          String photoUrl = res[i].photoUrl;
          addConversation(
              currentUserID, res[i].uid, messages, photoUrl, DateTime.now());
        }
        madeNewConversations = true;
      }
    }
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

  Future<List<PayUser>> appendConversations(List<PayUser> peeps) async {
    final List<Conversation> allConvos = await getAllConversations();
    Map<PayUser, List<Conversation>> mp =
        new Map<PayUser, List<Conversation>>();

    //get a map of each PayUser to their conversations, then append them into the actual Object.
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

  Future<List<Map<String, dynamic>>> getUserConversations() async {
    CollectionReference conv =
        FirebaseFirestore.instance.collection('conversations');
    User? user = auth.currentUser;
    String id = user?.uid as String;
    List<Map<String, dynamic>> ans = [];
    final QuerySnapshot res = await conv.where('userId', isEqualTo: id).get();
    res.docs.forEach((element) {
      // print("We are in the get user convos");
      print(element.data());
      ans.add(element.data() as Map<String, dynamic>);
    });
    return ans;
  }

  Future<void> addConversation(
      String userId,
      String peerId,
      List<Map<String, dynamic>> messages,
      String photoUrl,
      DateTime time) async {
    String convId = getConversationID(userId, peerId);
    CollectionReference conv =
        FirebaseFirestore.instance.collection('conversations');

    bool flag = true;

    final QuerySnapshot res =
        await conv.where('conversationId', isEqualTo: convId).get();
    if (res.docs.length > 0) {
      print("Conversation Exists");
      Map<String, dynamic> data = res.docs[0].data() as Map<String, dynamic>;
      List<dynamic> currentMessages = data['message'];
      currentMessages.addAll(messages);
      await conv.doc(res.docs[0].id).update({'message': currentMessages});
      return;
    }

    Map<String, dynamic> convData = Map<String, dynamic>();

    convData['conversationId'] = convId;
    convData['userId'] = userId;
    convData['peerId'] = peerId;
    convData['photoUrl'] = photoUrl;
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

  Future<num> updateDebt(Map<String, dynamic> conversation) async {
    CollectionReference conv =
        FirebaseFirestore.instance.collection('conversations');
    QuerySnapshot res = await conv
        .where('conversationId', isEqualTo: conversation['conversationId'])
        .get();
    if (res.docs.length > 0) {
      Map<String, dynamic> data = res.docs[0].data() as Map<String, dynamic>;

      print(conversation['debt'].toString());
      await conv.doc(res.docs[0].id).update({'debt': conversation['debt']});
      return conversation['debt'];
    }
    return -1;
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
  //add conversations AFTER creating the object.
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
