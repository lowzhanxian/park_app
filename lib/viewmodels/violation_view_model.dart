import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/violation.dart';
import '../helpers/database_help.dart';

class ViolationViewModel extends ChangeNotifier {
  final date_Controller = TextEditingController();
  final details_Controller = TextEditingController();
  Uint8List? path_Image;

  List<Violation> _violations = [];
  List<Violation> get violations => _violations;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _validateInputs() {
    bool isValid = true;
    if (date_Controller.text.isEmpty) {
      _errorMessage = "Date Required";
      isValid = false;
    } else if (details_Controller.text.isEmpty) {
      _errorMessage = "Details Required";
      isValid = false;
    } else if (path_Image == null) {
      _errorMessage = "Image Required";
      isValid = false;
    } else {
      _errorMessage = null;
    }
    notifyListeners();
    return isValid;
  }

  Future<void> fetchViolations(int userId) async {
    _violations = await Db_Helper().getViolationDetails(userId);
    notifyListeners();
  }

  Future<void> addViolation(int userId) async {
    if (!_validateInputs()) return;

    Violation newViolation = Violation(
      userId: userId,
      date: date_Controller.text,
      path_image: path_Image,
      details_report: details_Controller.text,
    );

    await Db_Helper().insertViolationDetails(newViolation);
    date_Controller.clear();
    details_Controller.clear();
    path_Image = null;
    fetchViolations(userId);
  }

  Future<void> updateViolation(Violation violation) async {
    if (!_validateInputs()) return;

    violation.date = date_Controller.text;
    violation.path_image = path_Image;
    violation.details_report = details_Controller.text;

    await Db_Helper().updateViolationDetails(violation);
    date_Controller.clear();
    details_Controller.clear();
    path_Image = null;
    fetchViolations(violation.userId);
  }

  Future<void> deleteViolation(int id, int userId) async {
    await Db_Helper().deleteViolationDetails(id);
    fetchViolations(userId);
  }

  Future<void> pickImage() async {
    // Request storage permission
    if (await Permission.storage.request().isGranted) {
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
        );
        if (result != null && result.files.single.bytes != null) {
          path_Image = result.files.single.bytes;
          notifyListeners();
        }
      } catch (e) {
        _errorMessage = "Failed to pick image: $e";
        notifyListeners();
      }
    } else {
      _errorMessage = "Storage permission is required to pick an image.";
      notifyListeners();
    }
  }

  @override
  void dispose() {
    date_Controller.dispose();
    details_Controller.dispose();
    super.dispose();
  }
}
