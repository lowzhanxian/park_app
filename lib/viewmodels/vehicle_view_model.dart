import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../helpers/database_help.dart';

class VehicleViewModel extends ChangeNotifier {
  List<Vehicle> _vehicles = [];
  List<Vehicle> get vehicles => _vehicles;

  final vehiclePlateNumController = TextEditingController();
  final vehicleNameController = TextEditingController();

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchVehicles(int userId) async {
    _vehicles = await Db_Helper().getVehicleDetails(userId);
    notifyListeners();
  }

  Future<void> addVehicle(int userId) async {
    if (vehiclePlateNumController.text.isEmpty || vehicleNameController.text.isEmpty) {
      _errorMessage = "All fields are required";
      notifyListeners();
      return;
    }

    Vehicle newVehicle = Vehicle(
      userId: userId,
      vehiclePlateNum: vehiclePlateNumController.text,
      vehicleName: vehicleNameController.text,
    );

    await Db_Helper().insertVehicleDetail(newVehicle);
    vehiclePlateNumController.clear();
    vehicleNameController.clear();
    fetchVehicles(userId);
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    if (vehiclePlateNumController.text.isEmpty || vehicleNameController.text.isEmpty) {
      _errorMessage = "All fields are required";
      notifyListeners();
      return;
    }

    vehicle.vehiclePlateNum = vehiclePlateNumController.text;
    vehicle.vehicleName = vehicleNameController.text;

    await Db_Helper().updateVehicleDetail(vehicle);
    vehiclePlateNumController.clear();
    vehicleNameController.clear();
    fetchVehicles(vehicle.userId);
  }

  Future<void> deleteVehicle(int id, int userId) async {
    await Db_Helper().deleteVehicleDetail(id);
    fetchVehicles(userId);
  }

  @override
  void dispose() {
    vehiclePlateNumController.dispose();
    vehicleNameController.dispose();
    super.dispose();
  }
}
