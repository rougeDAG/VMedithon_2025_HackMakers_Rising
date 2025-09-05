class Dose {
  final String uid; // Unique ID for the dose log itself
  final String userId; // The ID of the user who took the dose
  final DateTime timestamp; // When the dose was administered
  final double eyeRednessScore; // The result from the ML model
  final String eyeImageURL; // URL to the stored eye image

  Dose({
    required this.uid,
    required this.userId,
    required this.timestamp,
    required this.eyeRednessScore,
    required this.eyeImageURL,
  });
}
