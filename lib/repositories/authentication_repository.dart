import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationRepository {

  final auth = FirebaseAuth.instance;

  // HANDLE GOOGLE SIGN IN \\
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn.instance.authenticate();
      final googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      return await auth.signInWithCredential(credential);
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  // HANDLE SIGN OUT \\
  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    await auth.signOut();
  }
}
