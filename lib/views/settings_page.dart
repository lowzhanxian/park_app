import 'package:flutter/material.dart';
import 'profile_management_page.dart';
import 'wallet_page.dart';
import '../helpers/database_help.dart';
import '../models/user.dart';

class SettingsPage extends StatefulWidget {
  final int userId;

  // Constructor with required userId parameter
  SettingsPage({required this.userId});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Future<User?> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = Db_Helper().getUserById(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<User?>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('User not found'));
            }
            else {
              User user = snapshot.data!;
              return Column(

                children: [
                  // username card
                  Card(
                    margin: EdgeInsets.only(bottom: 20),
                    child: ListTile(
                      tileColor: Colors.white,
                      leading: Icon(Icons.person, size: 40,color: Colors.black,),
                      title: Text(user.username, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black54)),
                      trailing: IconButton(
                        icon: Icon(Icons.edit, color: Colors.deepOrange),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProfileManagementPage(userId: widget.userId)),
                          );
                        },
                      ),
                    ),
                  ),

                  // Wallet button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WalletPage(userId: widget.userId)),
                        );
                      },
                      icon: Icon(Icons.account_balance_wallet, color: Colors.grey),
                      label: Text(
                        'Wallet',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white12, foregroundColor: Colors.white, padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
