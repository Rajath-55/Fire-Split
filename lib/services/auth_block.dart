// import 'package:firesplit/services/loginservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firesplit/services/databaseManager.dart';
import 'package:firesplit/services/loginservice.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthBlock {
  final authService = AuthService();
  final googleSignIn = GoogleSignIn(scopes: ['email']);
  Stream<User?> get currentUser => authService.currentUser;

  loginGoogle() async {
    try {
      final GoogleSignInAccount googleUser =
          await googleSignIn.signIn() as GoogleSignInAccount;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final result = await authService.signInWithCredential(credential);

      print('${result.user?.displayName}');
    } catch (error) {
      print(error);
    }
  }

  logout() {
    print("Logout called");
    //so that when we login again there is a new call made to add conversations if they don't exist.
    DatabaseManager.madeNewConversations = false;
    authService.signOut();
  }
}
