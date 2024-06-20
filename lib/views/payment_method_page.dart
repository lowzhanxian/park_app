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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                margin: EdgeInsets.symmetric(vertical: 10),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: Icon(Icons.credit_card_outlined, color: Colors.white, size: 40),
                  title: Text('Debit/Credit Card', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onTap: () => _selectPaymentMethod(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
