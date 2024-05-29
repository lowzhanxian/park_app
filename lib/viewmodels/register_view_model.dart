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

  void register(BuildContext context) async {
    if (passwordController.text == confirm_passwordController.text) {
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
    } else {
      // Handle password mismatch error
    }
    notifyListeners();
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
