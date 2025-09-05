import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:acudrop/presentation/providers/auth_provider.dart';
import 'package:acudrop/presentation/screens/home_screen.dart';
import 'package:acudrop/presentation/screens/login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // Listens to changes in the AuthProvider.
    final authProvider = Provider.of<AuthProvider>(context);

    // A switch statement to determine the UI based on the auth state.
    switch (authProvider.authState) {
      case AuthState.authenticated:
        // If authenticated, show the home screen.
        return const HomeScreen();
      case AuthState.unauthenticated:
        // If not authenticated, show the login screen.
        return const LoginScreen();
      case AuthState.uninitialized:
      default:
        // While the app is figuring out the auth state, show a loading spinner.
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
    }
  }
}
