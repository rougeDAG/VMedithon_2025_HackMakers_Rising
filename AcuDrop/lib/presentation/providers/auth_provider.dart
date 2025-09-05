import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:acudrop/domain/repositories/auth_repository.dart';

// An enum to represent the possible states of authentication.
enum AuthState { uninitialized, authenticated, unauthenticated }

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository;
  User? _user;
  AuthState _authState = AuthState.uninitialized;
  String _error = '';

  // The constructor takes the repository as a dependency.
  AuthProvider(this._authRepository) {
    // Listen to the user stream from the repository.
    _authRepository.user.listen((user) {
      _user = user;
      _authState =
          user == null ? AuthState.unauthenticated : AuthState.authenticated;
      // Notify any listening widgets that the state has changed.
      notifyListeners();
    });
  }

  // Public getters to expose the state to the UI.
  User? get user => _user;
  AuthState get authState => _authState;
  String get error => _error;

  // A method for the UI to call to sign in.
  Future<void> signIn(String email, String password) async {
    try {
      _error = '';
      await _authRepository.signInWithEmailAndPassword(email, password);
    } catch (e) {
      _error = e.toString().split(']')[1].trim(); // Format the error message.
      notifyListeners();
      rethrow;
    }
  }

  // A method for the UI to call to sign up.
  Future<void> signUp(String email, String password) async {
    try {
      _error = '';
      await _authRepository.registerWithEmailAndPassword(email, password);
    } catch (e) {
      _error = e.toString().split(']')[1].trim();
      notifyListeners();
      rethrow;
    }
  }

  // A method for the UI to call to sign out.
  Future<void> signOut() async {
    await _authRepository.signOut();
  }
}
