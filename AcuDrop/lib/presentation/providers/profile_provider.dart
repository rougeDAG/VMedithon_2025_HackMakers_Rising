import 'package:flutter/foundation.dart';
import 'package:acudrop/domain/repositories/user_repository.dart';

class ProfileProvider with ChangeNotifier {
  final UserRepository _userRepository;

  ProfileProvider(this._userRepository);

  // UPDATED: Method for the UI to call to update the user's schedule and frequency.
  Future<void> updateUserSchedule(
      String uid, int dosesPerDay, List<String> schedule) async {
    try {
      await _userRepository.updateUserSchedule(uid, dosesPerDay, schedule);
    } catch (e) {
      debugPrint("Error updating schedule: $e");
    }
  }
}
