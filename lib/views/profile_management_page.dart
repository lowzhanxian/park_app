import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../viewmodels/register_view_model.dart';

class ProfileManagementPage extends StatelessWidget {
  final int userId;

  ProfileManagementPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterViewModel()..fetchUsers(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Profile Management'),
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

                    //register title
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

                    //-------input field start ------
                    //full name input field
                    SizedBox(height: 25),
                    TextField(
                      controller: viewModel.full_nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        labelStyle: TextStyle(color: Colors.white),
                        errorText: viewModel.full_name_validate,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
                      ],
                    ),

                    //username input field
                    SizedBox(height: 25),
                    TextField(
                      controller: viewModel.usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username:',
                        labelStyle: TextStyle(color: Colors.white),
                        errorText: viewModel.username_validate,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                      ),
                    ),

                    //contact input field
                    SizedBox(height: 25),
                    TextField(
                      controller: viewModel.contact_numberController,
                      decoration: InputDecoration(
                        labelText: 'Contact Number:',
                        labelStyle: TextStyle(color: Colors.white),
                        errorText: viewModel.contact_number_validate,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],//input format
                    ),

                    //email
                    SizedBox(height: 25),
                    TextField(
                      controller: viewModel.email_addressController,
                      decoration: InputDecoration(
                        labelText: 'Email Address:',
                        labelStyle: TextStyle(color: Colors.white),
                        errorText: viewModel.email_address_validate,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                      ),
                    ),

                    //password
                    SizedBox(height: 25),
                    TextField(
                      controller: viewModel.passwordController,
                      obscureText: !viewModel.displayPassword,
                      decoration: InputDecoration(
                          labelText: 'Create Password:',
                          labelStyle: TextStyle(color: Colors.white),
                          errorText: viewModel.password_validate,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          suffixIcon:IconButton(
                            icon: Icon(
                              viewModel.displayPassword? Icons.visibility:Icons.visibility_off,
                              color: Colors.white,
                            ),
                            onPressed: (){
                              viewModel.toggleDisplayPassword();
                            },
                          )
                      ),
                    ),

                    //confirm password
                    SizedBox(height: 25),
                    TextField(
                      controller: viewModel.confirm_passwordController,
                      obscureText: !viewModel.displayPassword,
                      decoration: InputDecoration(
                          labelText: 'Confirmation Password:',
                          labelStyle: TextStyle(color: Colors.white),
                          errorText: viewModel.confirm_password_validate,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          suffixIcon:IconButton(
                            icon: Icon(
                              viewModel.displayPassword? Icons.visibility:Icons.visibility_off,
                              color: Colors.white,
                            ),
                            onPressed: (){
                              viewModel.toggleDisplayPassword();
                            },
                          )
                      ),
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
                          'Save details',
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