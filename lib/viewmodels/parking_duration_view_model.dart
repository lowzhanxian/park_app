import 'package:flutter/material.dart';
import '../models/parking_details.dart';
import '../helpers/database_help.dart';

class ParkingDetailsViewModel extends ChangeNotifier {
  final Db_Helper _dbHelper = Db_Helper();

  Future<void> insertParkingDetails(ParkingDetails parkingDetails) async {
    try {
      // Validate parking details
      if (_validateParkingDetails(parkingDetails)) {
        await _dbHelper.insertParkingDetails(parkingDetails);
        notifyListeners();
        print("Parking details inserted successfully.");
      } else {
        print("Validation failed: Invalid parking details.");
      }
    } catch (e) {
      print("Error inserting parking details: $e");
    }
  }

  Future<double?> getWalletBalance(int userId) async {
    try {
      double? balance = await _dbHelper.getWalletBalance(userId);
      print("Wallet balance retrieved: $balance");
      return balance;
    } catch (e) {
      print("Error retrieving wallet balance: $e");
      return null;
    }
  }

  Future<void> updateWalletBalance(int userId, double newBalance) async {
    try {
      // Validate new balance
      if (_validateBalance(newBalance)) {
        await _dbHelper.updateWalletBalance(userId, newBalance);
        notifyListeners();
        print("Wallet balance updated to: $newBalance");
      } else {
        print("Validation failed: Invalid balance amount.");
      }
    } catch (e) {
      print("Error updating wallet balance: $e");
    }
  }

  bool _validateParkingDetails(ParkingDetails parkingDetails) {
    if (parkingDetails.userId <= 0) {
      return false;
    }
    if (parkingDetails.vehiclePlateNum.isEmpty) {
      return false;
    }
    if (parkingDetails.vehicleType.isEmpty) {
      return false;
    }
    if (parkingDetails.parkingLocation.isEmpty) {
      return false;
    }
    if (parkingDetails.roadName.isEmpty) {
      return false;
    }
    if (parkingDetails.duration <= 0) {
      return false;
    }
    if (parkingDetails.totalPrice < 0) {
      return false;
    }
    if (parkingDetails.date.isEmpty) {
      return false;
    }
    return true;
  }

  bool _validateBalance(double balance) {
    return balance >= 0;
  }
}
