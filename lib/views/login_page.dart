import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_view_model.dart';
import 'register.dart';

class SignPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Parking App'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Consumer<LoginViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: viewModel.usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username:',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  TextField(
                    controller: viewModel.passwordController,
                    obscureText: !viewModel.showPassword,
                    decoration: InputDecoration(
                      labelText: 'Password:',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          viewModel.showPassword ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          viewModel.togglePasswordVisibility();
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  if (viewModel.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        viewModel.errorMessage!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  if (viewModel.successMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        viewModel.successMessage!,
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        viewModel.login();
                      },
                      icon: Icon(Icons.login, color: Colors.white),
                      label: Text(
                        'Sign In',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 20),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.blue)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('OR', style: TextStyle(color: Colors.blue)),
                      ),
                      Expanded(child: Divider(color: Colors.blue)),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => registerPage()),
                      );
                    },
                    icon: Icon(Icons.person_add, color: Colors.white),
                    label: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.blue)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('New user have to sign up account', style: TextStyle(color: Colors.blue)),
                      ),
                      Expanded(child: Divider(color: Colors.blue)),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
