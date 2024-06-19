import 'package:flutter/material.dart';
import 'login_page.dart';
import 'vehicle_page.dart';
import 'settings_page.dart';
import 'selectparking_page.dart';
import 'violation_page.dart';
import 'wallet_page.dart';
import 'compound_payment_page.dart';
import '../helpers/database_help.dart';
import '../models/user.dart';
import '../models/parking_details.dart';
import 'parking_history_page.dart';

import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final int userId;

  HomePage({required this.userId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Db_Helper database_helper = Db_Helper();
  String? username;
  double? wallet_balance;
  ParkingDetails? _latestParkingDetails;

  @override
  void initState() {
    super.initState();
    display_userData();
  }

  Future<void> display_userData() async {
    User? user = await database_helper.getUserById(widget.userId);
    double? balance = await database_helper.getWalletBalance(widget.userId);
    ParkingDetails? parkingDetails = await database_helper.getLatestParkingDetails(widget.userId);
    setState(() {
      username = user?.username;
      wallet_balance = balance ?? 0.0;
      _latestParkingDetails = parkingDetails;
    });
  }

  void updateBalance() async {
    double? balance = await database_helper.getWalletBalance(widget.userId);
    setState(() {
      wallet_balance = balance ?? 0.0;
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
            Text('Welcome ${username ?? ''}'),
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
            if (wallet_balance != null)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Wallet: RM${wallet_balance!.toStringAsFixed(2)}',
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
                        'Date: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(_latestParkingDetails!.date).toLocal())}', // Convert the date to local time and format it
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ParkingHistoryPage(userId: widget.userId)),
                      );
                    },
                  ),

                  _buildGridButton(
                    icon: Icons.report,
                    label: 'Feedback',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FeedbackPage(userId: widget.userId)),
                      );
                    },
                  ),
                  _buildGridButton(
                    icon: Icons.report,
                    label: 'Compound',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CompoundPaymentPage(userId: widget.userId, onBalanceUpdated: updateBalance)),
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
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.black, size: 30),
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
