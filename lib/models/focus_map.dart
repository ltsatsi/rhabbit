// Programmer name        : Lebogang Tsatsi
// Contact                : ltsatsi18@gmail.com
// Organization           : L Tsatsi
// Purpose                : Productivity app

class FocusMap {
  final String id;
  final int count;
  final DateTime date;

  final String userId;

  FocusMap({
    required this.id,
    required this.count,
    required this.date,
    required this.userId,
  });

  FocusMap copyWith({int? count}) {
    return FocusMap(
      id: id,
      count: count ?? this.count,
      date: date,
      userId: userId,
    );
  } // end method

  // convert json data --> dart obj
  factory FocusMap.fromJson(Map<String, dynamic> json) {
    return FocusMap(
      id: json['id'].toString(),
      count: json['count'],
      date: DateTime.parse(json['date']),
      userId: json['user_id'].toString(),
    );
  } // end method

  // convert dart obj --> json data
  Map<String, dynamic> toJson() {
    return {'id': id, 'count': count, 'date': date, 'user_id': userId};
  } // end class
} // end class
