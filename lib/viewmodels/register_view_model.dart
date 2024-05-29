import 'package:flutter/material.dart';
import '../models/user.dart';
import '../helpers/database_help.dart';  // Updated import statement

class RegisterViewModel extends ChangeNotifier {
  final full_nameController = TextEditingController();
  final usernameController = TextEditingController();
  final contact_numberController = TextEditingController();
  final email_addressController = TextEditingController();
  final passwordController = TextEditingController();
  final confirm_passwordController = TextEditingController();


  List<User> _users = [];
  List<User> get users => _users;

  //set the validation
  String? full_name_validate;
  String?username_validate;
  String?contact_number_validate;
  String?email_address_validate;
  String?password_validate;
  String?confirm_password_validate;

  bool _validateInputs() {
    bool isValid = true;

    if (full_nameController.text.isEmpty) {
      full_name_validate = 'Full Name Required';
      isValid = false;
    } else if (full_nameController.text.split(' ').length < 3) {
      full_name_validate = 'Correct Full Name Format Required';
      isValid = false;
    } else {
      full_name_validate = null;
    }

    if (usernameController.text.isEmpty) {
      username_validate = 'Username Required';
      isValid = false;
    } else if (usernameController.text.length < 4) {
      username_validate = 'Correct Username Format Required ';
      isValid = false;
    } else {
      username_validate = null;
    }

    if (contact_numberController.text.isEmpty) {
      contact_number_validate = 'Contact Number Required';
      isValid = false;
    } else if (!contact_numberController.text.startsWith('01')) {
      contact_number_validate = 'Contact Number must start with 01';
      isValid = false;
    } else if (contact_numberController.text.length < 10 || contact_numberController.text.length > 11) {
      contact_number_validate = 'Correct Contact Number Format Required';
      isValid = false;
    } else {
      contact_number_validate = null;
    }

    if (email_addressController.text.isEmpty) {
      email_address_validate = 'Email Address Required';
      isValid = false;
    } else if (!_isValidEmail(email_addressController.text)) {
      email_address_validate = 'Correct Email Address Format Required';
      isValid = false;
    } else {
      email_address_validate = null;
    }

    if (passwordController.text.isEmpty) {
      password_validate = 'Password Required';
      isValid = false;
    } else {
      password_validate = null;
    }

    if (confirm_passwordController.text != passwordController.text) {
      confirm_password_validate = 'Password Not Match';
      isValid = false;
    } else {
      confirm_password_validate = null;
    }

    notifyListeners();
    return isValid;
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  void register(BuildContext context) async {
    if (_validateInputs()) {
      User newUser = User(
        full_name: full_nameController.text,
        username: usernameController.text,
        contact_number: contact_numberController.text,
        email_address: email_addressController.text,
        password: passwordController.text,
      );
      await Db_Helper().insertUser(newUser);
      showSuccessMessage(context);
      fetchUsers();
    }
  }

  void showSuccessMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("User registered successfully!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchUsers() async {
    _users = await Db_Helper().getAllUsers();
    notifyListeners();
  }

  @override
  void dispose() {
    full_nameController.dispose();
    usernameController.dispose();
    contact_numberController.dispose();
    email_addressController.dispose();
    passwordController.dispose();
    confirm_passwordController.dispose();
    super.dispose();
  }
}
