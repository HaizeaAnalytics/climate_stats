import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String?> signIn(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Signed in!";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> signUp(
      {required String email,
      required String password,
      required String firstName,
      required String lastName,
      required phoneNumber}) async {
    try {
      UserCredential result = (await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password));
      User? user = result.user;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('userInfo')
            .doc(user.uid)
            .set({
          'email': email,
          'firstName': firstName,
          'lastName': lastName,
          'phoneNumber': phoneNumber,
          'favourites': {}
        });
        return "Signed up!";
      } else {
        throw Error();
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
