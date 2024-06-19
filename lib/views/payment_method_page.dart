import 'package:flutter/material.dart';
import 'cardpayment_page.dart'; // Import the card payment page

class PaymentMethodPage extends StatelessWidget {
  final int userId;

  PaymentMethodPage({required this.userId});

  void _selectPaymentMethod(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CardPaymentPage(userId: userId),
      ),
    ).then((result) {
      if (result == true) {
        Navigator.of(context).pop(true); // Return to previous page with result
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Select Payment Method'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _selectPaymentMethod(context),
                child: Text('Debit/Credit Card'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
