import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../helpers/database_help.dart';
import '../models/violation.dart';

class ViolationViewModel extends ChangeNotifier {
  final date_Controller = TextEditingController();
  final carColor_Controller = TextEditingController();
  final carPlate_Controller = TextEditingController();
  final carType_Controller = TextEditingController();
  final details_Controller = TextEditingController();

  String? dateError;
  String? carColorError;
  String? carPlateError;
  String? carTypeError;
  String? detailsError;

  List<Violation> _violations = [];
  List<Violation> get violations => _violations;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _validateInputs() {
    bool isValid = true;

    if (date_Controller.text.isEmpty) {
      dateError = 'Date Required';
      isValid = false;
    } else {
      dateError = null;
    }

    if (carColor_Controller.text.isEmpty) {
      carColorError = 'Car Details Required';
      isValid = false;
    } else {
      carColorError = null;
    }

    if (carPlate_Controller.text.isEmpty) {
      carPlateError = 'Car Details Required';
      isValid = false;
    } else {
      carPlateError = null;
    }

    if (carType_Controller.text.isEmpty) {
      carTypeError = 'Car Details Required';
      isValid = false;
    } else {
      carTypeError = null;
    }

    if (details_Controller.text.isEmpty) {
      detailsError = 'Description Required';
      isValid = false;
    } else {
      detailsError = null;
    }

    notifyListeners();
    return isValid;
  }

  Future<void> fetchViolations(int userId) async {
    _violations = await Db_Helper().getViolationDetails(userId);
    notifyListeners();
  }

  Future<void> addViolation(int userId, BuildContext context) async {
    if (!_validateInputs()) return;

    Violation newViolation = Violation(
      userId: userId,
      date: date_Controller.text,
      car_color: carColor_Controller.text,
      car_plate: carPlate_Controller.text,
      car_type: carType_Controller.text,
      details_report: details_Controller.text,
      full_name: await _fetchUsername(userId),
    );

    await Db_Helper().insertViolationDetails(newViolation);
    date_Controller.clear();
    carColor_Controller.clear();
    carPlate_Controller.clear();
    carType_Controller.clear();
    details_Controller.clear();
    fetchViolations(userId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Violation submitted successfully!')),
    );
  }

  Future<void> updateViolation(Violation violation, BuildContext context) async {
    if (!_validateInputs()) return;

    violation.date = date_Controller.text;
    violation.car_color = carColor_Controller.text;
    violation.car_plate = carPlate_Controller.text;
    violation.car_type = carType_Controller.text;
    violation.details_report = details_Controller.text;

    await Db_Helper().updateViolationDetails(violation);
    fetchViolations(violation.userId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Violation updated successfully!')),
    );
  }

  Future<void> deleteViolation(int id, int userId) async {
    await Db_Helper().deleteViolationDetails(id);
    fetchViolations(userId);
  }

  Future<void> pickDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime threedaysago = now.subtract(Duration(days: 2));
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: threedaysago,
      lastDate: now,
    );
    if (picked != null) {
      date_Controller.text = DateFormat('yyyy-MM-dd').format(picked);
      notifyListeners();
    }
  }

  Future<String> _fetchUsername(int userId) async {
    final user = await Db_Helper().getUserById(userId);
    return user?.full_name ?? 'Unknown';
  }

  @override
  void dispose() {
    date_Controller.dispose();
    carColor_Controller.dispose();
    carPlate_Controller.dispose();
    carType_Controller.dispose();
    details_Controller.dispose();
    super.dispose();
  }
}
