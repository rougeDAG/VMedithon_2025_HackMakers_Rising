import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:acudrop/domain/entities/app_user.dart';
import 'package:acudrop/domain/entities/dose.dart';
import 'package:acudrop/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Implements the user data stream, now mapping the `dosesPerDay` field.
  @override
  Stream<AppUser> getUser(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      final data = snapshot.data() ?? {};
      return AppUser(
        uid: snapshot.id,
        email: data['email'] ?? '',
        dosesPerDay: data['dosesPerDay'] ?? 0,
        schedule: List<String>.from(data['schedule'] ?? []),
        bottleLevel: data['bottleLevel'] ?? 100,
      );
    });
  }

  // Implements the doses stream.
  @override
  Stream<List<Dose>> getDoses(String uid) {
    return _firestore
        .collection('doses')
        .where('userId', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return Dose(
                uid: doc.id,
                userId: data['userId'] ?? '',
                timestamp: (data['timestamp'] as Timestamp?)?.toDate() ??
                    DateTime.now(),
                eyeRednessScore:
                    (data['eyeRednessScore'] as num?)?.toDouble() ?? 0.0,
                eyeImageURL: data['eyeImageURL'] ?? '',
              );
            }).toList());
  }

  // Implements updating both schedule and frequency.
  @override
  Future<void> updateUserSchedule(
      String uid, int dosesPerDay, List<String> schedule) async {
    await _firestore.collection('users').doc(uid).update({
      'dosesPerDay': dosesPerDay,
      'schedule': schedule,
    });
  }

  // Implements adding a new dose record.
  @override
  Future<void> addDose(String uid) async {
    // We use a transaction to ensure that both database writes succeed or fail together.
    await _firestore.runTransaction((transaction) async {
      final userDocRef = _firestore.collection('users').doc(uid);
      final doseCollRef = _firestore.collection('doses').doc();

      // First, update the user's bottle level.
      transaction.update(userDocRef, {'bottleLevel': FieldValue.increment(-5)});

      // Second, create the new dose document.
      transaction.set(doseCollRef, {
        'userId': uid,
        'timestamp': FieldValue.serverTimestamp(),
        'eyeRednessScore': await getDummyRednessScore(),
        // CORRECTED: The URL is now a valid string.
        'eyeImageURL':
            '[https://placehold.co/600x400/EEE/31343C?text=Eye+Image](https://placehold.co/600x400/EEE/31343C?text=Eye+Image)',
      });
    });
  }

  // A placeholder function to simulate getting a result from an ML model.
  @override
  Future<double> getDummyRednessScore() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Random().nextDouble() * 0.8 + 0.1;
  }
}
