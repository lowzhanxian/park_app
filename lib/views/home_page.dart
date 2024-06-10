import 'package:flutter/material.dart';
import 'login_page.dart';
import 'vehicle_page.dart';
import 'settings_page.dart';
import 'selectparking_page.dart'; // Import the new page
import 'violation_page.dart'; // Import the violation page
import '../helpers/database_help.dart';
import '../models/user.dart';

class HomePage extends StatefulWidget {
  final int userId;

  HomePage({required this.userId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Db_Helper _dbHelper = Db_Helper();
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    User? user = await _dbHelper.getUserById(widget.userId);
    setState(() {
      _username = user?.username;
    });
  }

  void _selectParkingLocation() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SelectParkingPage(userId: widget.userId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Welcome ${_username ?? ''}'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildGridButton(
              icon: Icons.local_parking,
              label: 'Book a Parking Now',
              onPressed: _selectParkingLocation,
            ),
            _buildGridButton(
              icon: Icons.car_rental,
              label: 'Manage Vehicles',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VehiclePage(userId: widget.userId)),
                );
              },
            ),
            _buildGridButton(
              icon: Icons.settings,
              label: 'Settings',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage(userId: widget.userId)),
                );
              },
            ),
            _buildGridButton(
              icon: Icons.info,
              label: 'View Parking Details',
              onPressed: () {
                // TODO: Navigate to parking details page
              },
            ),
            _buildGridButton(
              icon: Icons.report,
              label: 'Manage Violations',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViolationPage(userId: widget.userId)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridButton({required IconData icon, required String label, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8), // Adjust the border radius as needed
      ),
      child: InkWell(
        onTap: onPressed,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 50), // Adjust the icon size as needed
              SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
