// Programmer name        : Lebogang Tsatsi
// Contact                : ltsatsi18@gmail.com
// Organization           : L Tsatsi
// Purpose                : Productivity app

class Profile {
  final String id;
  final String username;
  final String userId;
  final DateTime createdAt;
  final DateTime? deletedAt;

  Profile({
    required this.id,
    required this.username,
    required this.userId,
    required this.createdAt,
    this.deletedAt,
  });

  // model updates / modifications
  Profile copyWith({DateTime? deletedAt}) {
    return Profile(
      id: id,
      username: username,
      userId: userId,
      createdAt: createdAt,
      deletedAt: deletedAt,
    );
  }

  // convert json data --> dart obj
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'].toString(),
      username: json['username'].toString(),
      userId: json['user_id'].toString(),
      createdAt: DateTime.parse(json['created_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
    );
  } // end method

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'user_id': userId,
      'created_at': createdAt,
      'deleted_at': deletedAt,
    };
  } // end method
} // end class
