import 'package:flutter/material.dart';
import 'package:acudrop/domain/repositories/user_repository.dart';

class HomeProvider with ChangeNotifier {
  final UserRepository _userRepository;

  HomeProvider(this._userRepository);

  // UPDATED: Now takes BuildContext to show a SnackBar message.
  Future<void> addDose(String uid, BuildContext context) async {
    try {
      await _userRepository.addDose(uid);
      // Show a success message if the write succeeds.
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dose registered successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Show an error message if the write fails.
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Error: Could not register dose. Check Firestore Rules.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      debugPrint("Error adding dose: $e");
    }
  }

  // Method to get the dummy ML score.
  Future<double> getDummyRednessScore() {
    return _userRepository.getDummyRednessScore();
  }
}
