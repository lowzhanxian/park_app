import 'dart:typed_data';

class Violation {
  int? id;
  int userId;
  String full_name;
  String date;
  String car_color;
  String car_plate;
  String car_type;
  String details_report;

  Violation({
    this.id,
    required this.userId,
    required this.full_name,
    required this.date,
    required this.car_color,
    required this.car_plate,
    required this.car_type,
    required this.details_report,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'full_name':full_name,
      'date': date,
      'car_color': car_color,
      'car_plate': car_plate,
      'car_type': car_type,
      'details_report': details_report,
    };
  }

  factory Violation.fromMap(Map<String, dynamic> map) {
    return Violation(
      id: map['id'],
      userId: map['user_id'],
      full_name: map['full_name'],
      date: map['date'],
      car_color: map['car_color'],
      car_plate: map['car_plate'],
      car_type: map['car_type'],
      details_report: map['details_report'],
    );
  }
}
