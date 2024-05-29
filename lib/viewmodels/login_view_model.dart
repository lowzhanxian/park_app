import 'package:flutter/material.dart';
import '../helpers/database_help.dart';
import '../models/user.dart';

class LoginViewModel extends ChangeNotifier {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool _showPassword = false;
  bool get showPassword => _showPassword;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _successMessage;
  String? get successMessage => _successMessage;

  void togglePasswordVisibility() {
    _showPassword = !_showPassword;
    notifyListeners();
  }

  Future<void> login() async {
    _errorMessage = null;
    _successMessage = null;

    String username = usernameController.text;
    String password = passwordController.text;

    try {
      User? user = await Db_Helper().getUser(username);
      if (user != null && user.password == password) {
        _successMessage = "Login successful!";
      } else {
        _errorMessage = "Invalid username or password.";
      }
    } catch (e) {
      _errorMessage = "An error occurred during login.";
    }

    notifyListeners();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
