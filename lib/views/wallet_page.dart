import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'reloadhistory_page.dart'; // Import the reload history page

class WalletPage extends StatefulWidget {
  final int userId;

  WalletPage({required this.userId});

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  double _balance = 10; // Initial balance
  final TextEditingController _amountController = TextEditingController();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBalance();
  }

  Future<void> _loadBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _balance = prefs.getDouble('balance_${widget.userId}') ?? 0.0;
      print("Loaded balance: $_balance"); // Debug print
    });
  }

  Future<void> _saveBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('balance_${widget.userId}', _balance);
    print("Saved balance: $_balance"); // Debug print
  }

  Future<void> _saveReloadHistory(double amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('history_${widget.userId}') ?? [];
    history.add('${DateTime.now().toIso8601String()} - RM$amount');
    await prefs.setStringList('history_${widget.userId}', history);
    print("Saved history: $history"); // Debug print
  }

  void _reloadBalance() {
    setState(() {
      double? amount = double.tryParse(_amountController.text);
      if (amount == null || amount <= 0) {
        _errorMessage = 'Please enter a valid amount.';
        _showMessage('No amount is reloaded into the wallet');
      } else {
        _balance += amount;
        _saveBalance();
        _saveReloadHistory(amount);
        _errorMessage = null;
        _amountController.clear();
        _showMessage('Wallet balance reloaded successfully');
      }
    });
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Wallet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Available Balance: RM${_balance.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter amount to add',
                errorText: _errorMessage,
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _viewReloadHistory,
              child: Text('Reload History'),
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
    );
  }
}
