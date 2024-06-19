import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../helpers/database_help.dart';

class CardPaymentPage extends StatefulWidget {
  final int userId;

  CardPaymentPage({required this.userId});

  @override
  _CardPaymentPageState createState() => _CardPaymentPageState();
}

class _CardPaymentPageState extends State<CardPaymentPage> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _tacController = TextEditingController();
  String? _cardErrorMessage;
  String? _expiryErrorMessage;
  String? _cvvErrorMessage;
  String? _tacErrorMessage;
  bool _isTacSent = false;
  bool _isTacFieldVisible = false;
  final Db_Helper _dbHelper = Db_Helper();

  void _savePaymentMethod() {
    if (_validateCardNumber() && _validateExpiryDate() && _validateCVV()) {
      // Show fake TAC sent message
      _showTacMessage('A fake TAC has been sent to your phone');
    }
  }

  bool _validateCardNumber() {
    if (_cardNumberController.text.length != 16) {
      setState(() {
        _cardErrorMessage = 'Please enter a valid 16-digit card number.';
      });
      return false;
    }
    setState(() {
      _cardErrorMessage = null;
    });
    return true;
  }

  bool _validateExpiryDate() {
    final regex = RegExp(r'^(0[1-9]|1[0-2])\/\d{4}$');
    if (!regex.hasMatch(_expiryDateController.text)) {
      setState(() {
        _expiryErrorMessage = 'Please enter a valid expiry date (MM/YYYY).';
      });
      return false;
    }
    setState(() {
      _expiryErrorMessage = null;
    });
    return true;
  }

  bool _validateCVV() {
    if (_cvvController.text.length != 3) {
      setState(() {
        _cvvErrorMessage = 'Please enter a valid 3-digit CVV.';
      });
      return false;
    }
    setState(() {
      _cvvErrorMessage = null;
    });
    return true;
  }

  bool _validateTac() {
    if (_tacController.text.length != 6) {
      setState(() {
        _tacErrorMessage = 'Please enter a valid 6-digit TAC.';
      });
      return false;
    }
    setState(() {
      _tacErrorMessage = null;
    });
    return true;
  }

  void _showTacMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _isTacFieldVisible = true;
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _reloadBalance() {
    if (_validateTac()) {
      // Assuming TAC validation is successful and balance reload is successful
      Navigator.of(context).pop(true); // Return to the previous page with result
    }
  }

  void _showMessage(String message, bool success) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                if (success) {
                  Navigator.of(context).pop();
                  setState(() {
                    _isTacFieldVisible = true;
                  });
                } else {
                  Navigator.of(context).pop();
                }
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
        centerTitle: true,
        title: Text('Card Payment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              maxLength: 16,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                labelText: 'Enter card number',
                errorText: _cardErrorMessage,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _expiryDateController,
              keyboardType: TextInputType.datetime,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                LengthLimitingTextInputFormatter(7),
              ],
              decoration: InputDecoration(
                labelText: 'Expiry Date (MM/YYYY)',
                errorText: _expiryErrorMessage,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _cvvController,
              keyboardType: TextInputType.number,
              maxLength: 3,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                labelText: 'CVV',
                errorText: _cvvErrorMessage,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _savePaymentMethod,
              child: Text('Submit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            if (_isTacFieldVisible) ...[
              SizedBox(height: 20),
              TextField(
                controller: _tacController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  labelText: 'Enter TAC',
                  errorText: _tacErrorMessage,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _reloadBalance,
                child: Text('Reload Balance'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
