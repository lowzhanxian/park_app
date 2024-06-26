import 'package:flutter/material.dart';
import '../helpers/database_help.dart'; // Adjust the import according to your project structure
import 'reloadhistory_page.dart'; // Adjust the import according to your project structure
import 'home_page.dart'; // Import the homepage
import 'payment_method_page.dart';

class WalletPage extends StatefulWidget {
  final int userId;

  WalletPage({required this.userId});

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  double? _balance;
  final TextEditingController _amountController = TextEditingController();
  String? _errorMessage;
  final Db_Helper _dbHelper = Db_Helper();

  @override
  void initState() {
    super.initState();
    _loadBalance();
  }

  Future<void> _loadBalance() async {
    double? balance = await _dbHelper.getWalletBalance(widget.userId);
    setState(() {
      _balance = balance ?? 0.0;
    });
  }

  Future<void> _saveBalance() async {
    if (_balance != null) {
      await _dbHelper.updateWalletBalance(widget.userId, _balance!);
    }
  }

  Future<void> _saveReloadHistory(double amount) async {
    await _dbHelper.insertReloadHistory(widget.userId, amount);
  }

  void _reloadBalance() async {
    double? amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      setState(() {
        _errorMessage = 'Please enter a valid amount.';
      });
      _showMessage('No amount is reloaded into the wallet');
    } else {
      // Redirect to PaymentMethodPage
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentMethodPage(userId: widget.userId),
        ),
      );

      // Check if the payment method was successfully entered
      if (result == true) {
        setState(() {
          _balance = (_balance ?? 0) + amount;
          _saveBalance();
          _saveReloadHistory(amount);
          _errorMessage = null;
          _amountController.clear();
          _showMessage('Wallet balance reloaded successfully');
        });
      } else {
        _showMessage('Payment method not entered. Reload cancelled.');
      }
    }
  }

  void _showMessage(String message) {
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
              },
            ),
          ],
        );
      },
    );
  }

  void _viewReloadHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReloadHistoryPage(userId: widget.userId),
      ),
    ).then((_) {
      // This will be called when ReloadHistoryPage is popped
      _loadBalance();
    });
  }

  void _navigateToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage(userId: widget.userId)),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Wallet'),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _balance == null
                ? CircularProgressIndicator()
                : Container(
              padding: EdgeInsets.all(10),

              child: Column(
                children: [
                  Text(
                    'Available Balance',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'RM${_balance!.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightGreen,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                errorText: _errorMessage,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,

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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _viewReloadHistory,
              child: Text('Reload History'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToHomePage,
              child: Text('Back to Home Page'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
