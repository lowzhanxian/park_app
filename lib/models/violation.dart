import 'dart:typed_data';

class Violation {
  int? id;
  int userId;
  String date;
  Uint8List? path_image;
  String details_report;

  Violation({
    this.id,
    required this.userId,
    required this.date,
    this.path_image,
    required this.details_report,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'date': date,
      'path_image': path_image,
      'details_report': details_report,
    };
  }

  factory Violation.fromMap(Map<String, dynamic> map) {
    return Violation(
      id: map['id'],
      userId: map['user_id'],
      date: map['date'],
      path_image: map['path_image'],
      details_report: map['details_report'],
    );
  }
}
