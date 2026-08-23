// Programmer name        : Lebogang Tsatsi
// Contact                : ltsatsi18@gmail.com
// Organization           : L Tsatsi
// Purpose                : Productivity app

class FocusSession {
  final String id;
  final String label;
  final Duration duration;
  final DateTime createdAt;

  final String userId;

  FocusSession({
    required this.id,
    required this.label,
    required this.duration,
    required this.createdAt,
    required this.userId,
  });

  FocusSession copyWith({String? label}) {
    return FocusSession(
      id: id,
      label: label ?? this.label,
      duration: duration,
      createdAt: createdAt,
      userId: userId,
    );
  } // end method

  // convert json data --> dart obj
  factory FocusSession.fromJson(Map<String, dynamic> json) {
    return FocusSession(
      id: json['id'].toString(),
      label: json['label'].toString(),

      // --- possible serialization error 'casting' ---
      duration: Duration(seconds: json['duration'] ?? 0),
      createdAt: DateTime.parse(json['created_at']),
      userId: json['user_id'].toString(),
    );
  } // end method

  // convert dart obj --> json data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'duration': duration.inSeconds,
      'created_at': createdAt,
      'user_id': userId,
    };
  } // end method
} // end class
