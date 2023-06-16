import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// class AuthService {
//   signInWithGoogle() async {
//     //sign in process
//     final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
//
//     //obtain auth details
//     final GoogleSignInAuthentication gAuth = await gUser!.authentication;
//
//     //credentials
//     final credential = GoogleAuthProvider.credential(
//       accessToken: gAuth.accessToken,
//       idToken: gAuth.idToken,
//     );
//
//     //sign in
//     return await FirebaseAuth.instance.signInWithCredential(credential);
//   }
// }

class AuthService {
  Future<UserCredential> signInWithGoogle() async {
    // Sign in process
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      // Obtain auth details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create credentials
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase using the credentials
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } else {
      throw FirebaseAuthException(
        code: 'sign_in_canceled',
        message: 'Sign in process was canceled by the user.',
      );
    }
  }
}
