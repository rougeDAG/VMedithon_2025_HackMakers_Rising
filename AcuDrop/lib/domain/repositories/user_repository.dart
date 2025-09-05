import 'package:acudrop/domain/entities/app_user.dart';
import 'package:acudrop/domain/entities/dose.dart';

abstract class UserRepository {
  // A stream to get real-time updates for a user's data.
  Stream<AppUser> getUser(String uid);

  // A stream to get a real-time list of all doses for a user.
  Stream<List<Dose>> getDoses(String uid);

  // UPDATED: A method to update the user's medication schedule and frequency.
  Future<void> updateUserSchedule(
      String uid, int dosesPerDay, List<String> schedule);

  // A method to log a new dose.
  Future<void> addDose(String uid);

  // A method to get the ML model's result (dummy for now).
  Future<double> getDummyRednessScore();
}
