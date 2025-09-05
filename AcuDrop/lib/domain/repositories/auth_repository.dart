import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  // A stream that notifies the app whenever the user's login state changes.
  Stream<User?> get user;

  // A method to sign in a user.
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password);

  // A method to register a new user.
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password);

  // A method to sign out the current user.
  Future<void> signOut();
}
