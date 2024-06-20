import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../helpers/database_help.dart';

class VehicleViewModel extends ChangeNotifier {
  final Db_Helper _dbHelper = Db_Helper();
  List<Vehicle> vehicles = [];
  String? errorMessage;
  final TextEditingController vehiclePlateNumController = TextEditingController();
  final TextEditingController vehicleNameController = TextEditingController();

  Future<void> fetchVehicles(int userId) async {
    try {
      vehicles = await _dbHelper.getVehicleDetails(userId);
      errorMessage = null;
    } catch (e) {
      errorMessage = 'Error fetching vehicles: $e';
    }
    notifyListeners();
  }

  bool _isValidPlateNumber(String plateNum) {
    final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');
    return validCharacters.hasMatch(plateNum);
  }

  Future<bool> _vehicleExists(int userId, String plateNum) async {
    List<Vehicle> existingVehicles = await _dbHelper.getVehicleDetails(userId);
    return existingVehicles.any((vehicle) => vehicle.vehiclePlateNum == plateNum);
  }

  Future<void> addVehicle(int userId) async {
    if (vehiclePlateNumController.text.isEmpty || vehicleNameController.text.isEmpty) {
      errorMessage = 'Vehicle Details Required';
    }
    else if (!_isValidPlateNumber(vehiclePlateNumController.text)) {
      errorMessage = 'Vehicle plate number can only contain alphabets and numbers';
    }

    //check car validation
    else if (await _vehicleExists(userId, vehiclePlateNumController.text)) {
      errorMessage = 'Car Plate Exists';
    }
    else {
      try {
        Vehicle newVehicle = Vehicle(
          userId: userId,
          vehiclePlateNum: vehiclePlateNumController.text,
          vehicleName: vehicleNameController.text,
        );
        await _dbHelper.insertVehicleDetail(newVehicle);
        await fetchVehicles(userId);
        errorMessage = null;
      } catch (e) {
        errorMessage = 'Error adding vehicle: $e';
      }
    }
    notifyListeners();
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    if (vehiclePlateNumController.text.isEmpty || vehicleNameController.text.isEmpty) {
      errorMessage = 'Vehicle Details Required';
    }
    else if (!_isValidPlateNumber(vehiclePlateNumController.text)) {
      errorMessage = 'Vehicle plate number can only contain alphabets and numbers';
    }
    //check car validation
    else if (await _vehicleExists(vehicle.userId, vehiclePlateNumController.text) && vehiclePlateNumController.text != vehicle.vehiclePlateNum) {
      errorMessage = 'Car Plate Exists';
    }
    else {
      try {
        vehicle.vehiclePlateNum = vehiclePlateNumController.text;
        vehicle.vehicleName = vehicleNameController.text;
        await _dbHelper.updateVehicleDetail(vehicle);
        await fetchVehicles(vehicle.userId);
        errorMessage = null;
      } catch (e) {
        errorMessage = 'Error updating vehicle: $e';
      }
    }
    notifyListeners();
  }

  Future<void> deleteVehicle(int vehicleId, int userId) async {
    try {
      await _dbHelper.deleteVehicleDetail(vehicleId);
      await fetchVehicles(userId);
      errorMessage = null;
    } catch (e) {
      errorMessage = 'Error deleting vehicle: $e';
    }
    notifyListeners();
  }
}
