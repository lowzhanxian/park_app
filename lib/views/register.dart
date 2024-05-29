import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/register_view_model.dart';

class registerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterViewModel()..fetchUsers(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Parking App'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Consumer<RegisterViewModel>(
              builder: (context, viewModel, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_add, color: Colors.white, size: 20),
                        SizedBox(width: 10),
                        Text(
                          'Registration Page',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
                    TextField(
                      controller: viewModel.full_nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
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
                      controller: viewModel.contact_numberController,
                      decoration: InputDecoration(
                        labelText: 'Contact Number:',
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
                      controller: viewModel.email_addressController,
                      decoration: InputDecoration(
                        labelText: 'Email Address:',
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
                      decoration: InputDecoration(
                        labelText: 'Create Password:',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                        suffixIcon: Icon(Icons.visibility, color: Colors.white),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 25),
                    TextField(
                      controller: viewModel.confirm_passwordController,
                      decoration: InputDecoration(
                        labelText: 'Confirmation Password:',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                        suffixIcon: Icon(Icons.visibility, color: Colors.white),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          viewModel.register(context);
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
                          padding: EdgeInsets.symmetric(vertical: 20),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Already Have an Account? Sign In',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Text(
                      'Registered Users:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...viewModel.users.map((user) => ListTile(
                      title: Text(user.full_name, style: TextStyle(color: Colors.white)),
                      subtitle: Text(user.username, style: TextStyle(color: Colors.white)),
                    )).toList(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
