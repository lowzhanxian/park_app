import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  final int userId;

  HistoryPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('History'),
      ),
      body: Center(
        child: Text(
          'History Page for User ID: $userId',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
