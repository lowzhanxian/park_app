class Vehicle {
  int? id;
  int userId;
  String vehiclePlateNum;
  String vehicleName;

  Vehicle({
    this.id,
    required this.userId,
    required this.vehiclePlateNum,
    required this.vehicleName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'vehicle_plateNum': vehiclePlateNum,
      'vehicle_name': vehicleName,
    };
  }

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      id: map['id'],
      userId: map['user_id'],
      vehiclePlateNum: map['vehicle_plateNum'],
      vehicleName: map['vehicle_name'],
    );
  }
}
