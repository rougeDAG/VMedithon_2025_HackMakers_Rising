import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:acudrop/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  // Get instances of the Firebase services.
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Implements the user stream by returning Firebase's own authStateChanges stream.
  @override
  Stream<User?> get user => _auth.authStateChanges();

  // Implements sign in by calling the Firebase auth method.
  @override
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      rethrow; // Pass the error up to the UI to be displayed.
    }
  }

  // Implements registration by calling the Firebase auth method.
  @override
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // IMPORTANT: After creating a user in Firebase Auth, we also create a
      // corresponding document in the Firestore database to store extra info.
      await _firestore.collection('users').doc(result.user!.uid).set({
        'email': email,
        'dosesPerDay': 0, // UPDATED: Initialize with 0 doses per day.
        'schedule': [], // Start with an empty schedule.
        'bottleLevel': 100, // Start with a full bottle.
      });
      return result;
    } catch (e) {
      rethrow;
    }
  }

  // Implements sign out by calling the Firebase method.
  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
