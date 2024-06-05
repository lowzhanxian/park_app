import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReloadHistoryPage extends StatefulWidget {
  final int userId;

  ReloadHistoryPage({required this.userId});

  @override
  _ReloadHistoryPageState createState() => _ReloadHistoryPageState();
}

class _ReloadHistoryPageState extends State<ReloadHistoryPage> {
  List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _history = prefs.getStringList('history_${widget.userId}') ?? [];
      print("Loaded history: $_history"); // Debug print
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Reload History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _history.isEmpty
            ? Center(
          child: Text(
            'No reload history available.',
            style: TextStyle(fontSize: 18),
          ),
        )
            : ListView.builder(
          itemCount: _history.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_history[index]),
            );
          },
        ),
      ),
    );
  }
}
