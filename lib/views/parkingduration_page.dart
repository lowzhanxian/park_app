import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import 'home_page.dart';

class ParkingDurationPage extends StatefulWidget {
  final int userId;
  final Vehicle selectedVehicle;
  final String parkingLocation;

  ParkingDurationPage({
    required this.userId,
    required this.selectedVehicle,
    required this.parkingLocation,
  });

  @override
  _ParkingDurationPageState createState() => _ParkingDurationPageState();
}

class _ParkingDurationPageState extends State<ParkingDurationPage> {
  double _duration = 1; // Initial duration in hours
  static const double pricePerHour = 0.50;

  double get _totalPrice => _duration * pricePerHour;

  void _updateDuration(double value) {
    setState(() {
      _duration = value;
    });
  }

  void _showBookingConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Booking Confirmed'),
          content: Text(
            'A total amount of RM${_totalPrice.toStringAsFixed(2)} will be deducted from your wallet.',
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).popUntil((route) => route.isFirst); // Pop all intermediate pages
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(userId: widget.userId), // Replace with your HomePage
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Parking Duration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Parking Location: ${widget.parkingLocation}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Selected Vehicle: ${widget.selectedVehicle.vehiclePlateNum}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Duration (hours): ${_duration.toStringAsFixed(1)}',
              style: TextStyle(fontSize: 18),
            ),
            Slider(
              min: 1,
              max: 24,
              divisions: 23,
              value: _duration,
              onChanged: _updateDuration,
              label: '${_duration.toStringAsFixed(1)} hours',
              activeColor: Colors.blue, // Change the color to blue
              inactiveColor: Colors.blue.withOpacity(0.3), // Lighter blue for inactive part
            ),
            SizedBox(height: 20),
            Text(
              'Total Price: RM${_totalPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _showBookingConfirmation,
              icon: Icon(Icons.check),
              label: Text('Confirm Booking'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 20),
                minimumSize: Size(double.infinity, 50), // Ensures the button fills the width
              ),
            ),
          ],
        ),
      ),
    );
  }
}
