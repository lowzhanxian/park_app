class ParkingDetails {
  final int? id;
  final int userId;
  final String vehiclePlateNum;
  final String vehicleType;
  final String parkingLocation;
  final String roadName;
  final double duration;
  final double totalPrice;
  final String date;

  ParkingDetails({
    this.id,
    required this.userId,
    required this.vehiclePlateNum,
    required this.vehicleType,
    required this.parkingLocation,
    required this.roadName,
    required this.duration,
    required this.totalPrice,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    var map = {
      'user_id': userId,
      'vehicle_plateNum': vehiclePlateNum,
      'vehicle_type': vehicleType,
      'parking_location': parkingLocation,
      'road_name': roadName,
      'duration': duration,
      'total_price': totalPrice,
      'date': date,
    };
    if (id != null) {
      map['id'] = id!;
    }
    return map;
  }

  static ParkingDetails fromMap(Map<String, dynamic> map) {
    return ParkingDetails(
      id: map['id'],
      userId: map['user_id'],
      vehiclePlateNum: map['vehicle_plateNum'],
      vehicleType: map['vehicle_type'],
      parkingLocation: map['parking_location'],
      roadName: map['road_name'],
      duration: map['duration'],
      totalPrice: map['total_price'],
      date: map['date'],
    );
  }
}
