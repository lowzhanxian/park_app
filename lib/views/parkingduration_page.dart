import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import 'home_page.dart';
import '../models/parking_details.dart';
import '../viewmodels/parking_duration_view_model.dart';
import 'package:provider/provider.dart';
import 'wallet_page.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class ParkingDurationPage extends StatefulWidget {
  final int userId;
  final Vehicle selectedVehicle;
  final String parkingLocation;
  final String roadName;

  ParkingDurationPage({
    required this.userId,
    required this.selectedVehicle,
    required this.parkingLocation,
    required this.roadName,
  });

  @override
  _ParkingDurationPageState createState() => _ParkingDurationPageState();
}

class _ParkingDurationPageState extends State<ParkingDurationPage> {
  double _duration = 1; // Initial duration in hours
  bool _isWholeDay = false;
  static const double pricePerHour = 0.50;
  static const double wholeDayPrice = 4.00;

  double get _totalPrice => _isFreeParking() ? 0.0 : (_isWholeDay ? wholeDayPrice : _duration * pricePerHour);

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    if (_isFreeParking()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showFreeParkingAlert();
      });
    }
  }

  bool _isFreeParking() {
    final now = tz.TZDateTime.now(tz.getLocation('Asia/Kuala_Lumpur'));
    final hour = now.hour;
    final minute = now.minute;
    if (hour > 18 || (hour == 18 && minute > 0) || hour < 9 || (hour == 9 && minute == 0)) {
      return true;
    }
    return false;
  }

  void _updateDuration(double value) {
    setState(() {
      _duration = value;
    });
  }

  void _toggleWholeDay(bool value) {
    setState(() {
      _isWholeDay = value;
    });
  }

  void _showBookingConfirmation(BuildContext context) async {
    final now = DateTime.now().toLocal();
    final parkingDetails = ParkingDetails(
      userId: widget.userId,
      vehiclePlateNum: widget.selectedVehicle.vehiclePlateNum,
      vehicleType: widget.selectedVehicle.vehicleName,
      parkingLocation: widget.parkingLocation,
      roadName: widget.roadName,
      duration: _isWholeDay ? 24 : _duration,
      totalPrice: _totalPrice,
      date: now.toIso8601String(), // Save the local time in ISO format
    );

    final viewModel = Provider.of<ParkingDetailsViewModel>(context, listen: false);
    final balance = await viewModel.getWalletBalance(widget.userId);

    if (balance != null && balance >= _totalPrice) {
      await viewModel.insertParkingDetails(parkingDetails);
      if (!_isFreeParking()) {
        await viewModel.updateWalletBalance(widget.userId, balance - _totalPrice);
      }

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
                      builder: (context) => HomePage(userId: widget.userId),
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Insufficient Balance'),
            content: Text('Your wallet balance is insufficient. Please top up your wallet.'),
            actions: <Widget>[
              TextButton(
                child: Text('Top Up Wallet'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WalletPage(userId: widget.userId),
                    ),
                  );
                },
              ),
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _showFreeParkingAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Free Parking Time'),
          content: Text('Parking is free between 6:01 PM and 8:59 AM. You do not need to pay for parking during this time.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).popUntil((route) => route.isFirst); // Pop all intermediate pages
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(userId: widget.userId),
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
            SizedBox(height: 10),
            Text(
              'Road Name: ${widget.roadName}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Selected Vehicle:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Plate Number: ${widget.selectedVehicle.vehiclePlateNum}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Car Type: ${widget.selectedVehicle.vehicleName}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            if (!_isFreeParking()) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Whole Day (RM4.00): ',
                    style: TextStyle(fontSize: 18),
                  ),
                  Switch(
                    value: _isWholeDay,
                    onChanged: _toggleWholeDay,
                  ),
                ],
              ),
              if (!_isWholeDay) ...[
                Text(
                  'Duration (hours): ${_duration.toStringAsFixed(1)}',
                  style: TextStyle(fontSize: 18),
                ),
                Slider(
                  min: 1,
                  max: 9,
                  divisions: 8,
                  value: _duration,
                  onChanged: _updateDuration,
                  label: '${_duration.toStringAsFixed(1)} hours',
                  activeColor: Colors.blue,
                  inactiveColor: Colors.blue.withOpacity(0.3),
                ),
              ],
              SizedBox(height: 20),
            ],
            Text(
              'Total Price: RM${_totalPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _showBookingConfirmation(context),
              icon: Icon(Icons.check),
              label: Text('Confirm Booking'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 20),
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
