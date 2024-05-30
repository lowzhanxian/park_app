import 'package:flutter/material.dart';
import 'package:park_app/views/home_page.dart';
import '../helpers/database_help.dart';
import '../models/user.dart';

class LoginViewModel extends ChangeNotifier {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  //show password
  bool _showPassword = false;
  bool get showPassword => _showPassword;

  //username and password error check
  String? _login_username_error;
  String? get login_usernameError => _login_username_error;
  String? _login_password_error;
  String? get login_passwordError => _login_password_error;

  //error
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  //success
  String? _successMessage;
  String? get successMessage => _successMessage;

  //function show and close display password
  void togglePasswordVisibility() {
    _showPassword = !_showPassword;
    notifyListeners();
  }

  bool _validateInputs() {
    bool isValid = true;
    if (usernameController.text.isEmpty) {
      _login_username_error = 'Username is required';
      isValid = false;
    } else {
      _login_username_error = null;
    }
    if (passwordController.text.isEmpty) {
      _login_password_error = 'Password is required';
      isValid = false;
    } else {
      _login_password_error = null;
    }
    notifyListeners();
    return isValid;
  }

  Future<void> login(BuildContext context) async {
    _errorMessage = null;
    _successMessage = null;

    if (_validateInputs()) {
      String username = usernameController.text;
      String password = passwordController.text;

      try {
        User? user = await Db_Helper().getUser(username);
        if (user != null && user.password == password) {
          _successMessage = "Login successful!";
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          _errorMessage = "Invalid username or password.";
        }
      } catch (e) {
        _errorMessage = "An error occurred during login.";
      }
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
