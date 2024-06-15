import 'package:flutter/material.dart';
import 'login_page.dart';
import 'vehicle_page.dart';
import 'settings_page.dart';
import 'selectparking_page.dart'; // Import the new page
import 'violation_page.dart'; // Import the violation page
import 'wallet_page.dart'; // Import the wallet page
import '../helpers/database_help.dart';
import '../models/user.dart';
import '../models/parking_details.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final int userId;

  HomePage({required this.userId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Db_Helper _dbHelper = Db_Helper();
  String? _username;
  double? _walletBalance;
  ParkingDetails? _latestParkingDetails;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = await _dbHelper.getUserById(widget.userId);
    double? balance = await _dbHelper.getWalletBalance(widget.userId);
    ParkingDetails? parkingDetails = await _dbHelper.getLatestParkingDetails(widget.userId);
    setState(() {
      _username = user?.username;
      _walletBalance = balance ?? 0.0;
      _latestParkingDetails = parkingDetails;
    });
  }

  bool _isParkingExpired() {
    if (_latestParkingDetails == null) return false;

    DateTime parkingEndTime = DateTime.parse(_latestParkingDetails!.date).add(Duration(hours: _latestParkingDetails!.duration.toInt()));
    return DateTime.now().isAfter(parkingEndTime);
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
        title: Column(
          children: [
            Text('Welcome ${_username ?? ''}'),
          ],
        ),
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_walletBalance != null)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Available Balance: RM${_walletBalance!.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => WalletPage(userId: widget.userId)),
                        );
                      },
                    ),
                  ],
                ),
              ),
            if (_latestParkingDetails != null && !_isParkingExpired())
              Padding(
                padding: const EdgeInsets.all(50),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Latest Parking',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Road Name: ${_latestParkingDetails!.roadName}',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Duration: ${_latestParkingDetails!.duration} hours',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Car Plate: ${_latestParkingDetails!.vehiclePlateNum} ',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Car: ${_latestParkingDetails!.vehicleType} ',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Total Price: RM${_latestParkingDetails!.totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Date: ${_latestParkingDetails!.date}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  _buildGridButton(
                    icon: Icons.local_parking,
                    label: 'Pay Park',
                    onPressed: _selectParkingLocation,
                  ),
                  _buildGridButton(
                    icon: Icons.car_rental_rounded,
                    label: 'Vehicles',
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
                    label: 'Violations',
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
          ],
        ),
      ),
    );
  }

  Widget _buildGridButton({required IconData icon, required String label, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8), // Adjust the border radius as needed
      ),
      child: InkWell(
        onTap: onPressed,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.black, size: 30), // Adjust the icon size as needed
              SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  color: Colors.black,
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
