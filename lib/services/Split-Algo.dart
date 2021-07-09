import 'package:firesplit/services/databaseManager.dart';

class GetMinSplit {
  //All conversations - Which hold the debt of a user
  late List<Conversation> conversations;
  late PayUser user;
  late Map<PayUser, List<Map<String, num>>> graph;
  late DatabaseManager manager;
  late List<PayUser> allUsers;

  GetMinSplit() {
    manager = new DatabaseManager();
  }

  void buildGraph() async {
    List<PayUser> allUsers = await manager.getAllUsers();
    this.allUsers = allUsers;

    //modeling the graph as User : pair<userName, debt> map
    allUsers.forEach((user) {
      user.conversations.forEach((conversation) {
        if (graph[user] == null) {
          graph[user] = [];
        }
        graph[user]?.add({conversation.peer: conversation.debt});
      });
    });
  }
}
