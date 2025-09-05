class AppUser {
  final String uid;
  final String email;
  final int dosesPerDay; // NEW: How many times a day to take medicine
  final List<String> schedule; // The specific times for the doses
  final int bottleLevel;

  AppUser({
    required this.uid,
    required this.email,
    required this.dosesPerDay,
    required this.schedule,
    required this.bottleLevel,
  });

  // Helper method for immutable updates.
  AppUser copyWith({
    String? uid,
    String? email,
    int? dosesPerDay,
    List<String>? schedule,
    int? bottleLevel,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      dosesPerDay: dosesPerDay ?? this.dosesPerDay,
      schedule: schedule ?? this.schedule,
      bottleLevel: bottleLevel ?? this.bottleLevel,
    );
  }
}
