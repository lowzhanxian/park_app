import 'package:flutter/material.dart';
import '../models/user.dart';
import '../helpers/database_help.dart';
import 'dart:async';

class ProfileViewModel extends ChangeNotifier {
  final full_nameController = TextEditingController();
  final usernameController = TextEditingController();
  final contact_numberController = TextEditingController();
  final email_addressController = TextEditingController();

  // Set the validation
  String? full_name_validate;
  String? username_validate;
  String? contact_number_validate;
  String? email_address_validate;

  // Fetch user details by ID
  Future<void> fetchUserById(int userId) async {
    try {
      User? user = await Db_Helper().getUserById(userId);
      if (user != null) {
        full_nameController.text = user.full_name;
        usernameController.text = user.username;
        contact_numberController.text = user.contact_number;
        email_addressController.text = user.email_address;
      }
      notifyListeners();
    } catch (e) {
      // Handle the error
      print(e);
    }
  }

  // Update user details
  Future<void> updateUserDetails(BuildContext context, int userId) async {
    if (_validateInputs()) {
      try {
        // Fetch current password from the database
        User? currentUser = await Db_Helper().getUserById(userId);
        if (currentUser != null) {
          User updatedUser = User(
            id: userId,
            full_name: full_nameController.text,
            username: usernameController.text,
            contact_number: contact_numberController.text,
            email_address: email_addressController.text,
            password: currentUser.password, // Retain the current password
          );

          await Db_Helper().updateUser(updatedUser);

          // Show success dialog and navigate to home page
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text('User profile updated successfully'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      Navigator.of(context).pop(true); // Navigate to home page
                    },
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        // Handle the error
        print(e);
      }
    }
  }

  // Validate inputs
  bool _validateInputs() {
    bool isValid = true;

    if (full_nameController.text.isEmpty) {
      full_name_validate = 'Full Name Required';
      isValid = false;
    } else if (full_nameController.text.length <= 2) {
      full_name_validate = 'Correct Full Name Required';
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

    notifyListeners();

    // Time duration to disappear the error message
    if (!isValid) {
      Timer(Duration(seconds: 3), () {
        full_name_validate = null;
        username_validate = null;
        contact_number_validate = null;
        email_address_validate = null;

        notifyListeners();
      });
    }

    return isValid;
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  @override
  void dispose() {
    full_nameController.dispose();
    usernameController.dispose();
    contact_numberController.dispose();
    email_addressController.dispose();
    super.dispose();
  }
}
