import 'package:flutter/material.dart';
import '../helpers/database_help.dart'; // Adjust the import according to your project structure

class ReloadHistoryPage extends StatefulWidget {
  final int userId;

  ReloadHistoryPage({required this.userId});

  @override
  _ReloadHistoryPageState createState() => _ReloadHistoryPageState();
}

class _ReloadHistoryPageState extends State<ReloadHistoryPage> {
  final Db_Helper _dbHelper = Db_Helper();
  List<Map<String, dynamic>> _reloadHistory = [];

  @override
  void initState() {
    super.initState();
    _loadReloadHistory();
  }

  Future<void> _loadReloadHistory() async {
    List<Map<String, dynamic>> history = await _dbHelper.getReloadHistory(widget.userId);
    setState(() {
      _reloadHistory = history;
    });
  }

  String _formatDateTime(String dateTime) {
    final date = DateTime.parse(dateTime);
    return '${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)} ${_twoDigits(date.hour)}:${_twoDigits(date.minute)}';
  }

  String _twoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }

  Future<void> _deleteAllHistory() async {
    await _dbHelper.deleteReloadHistory(widget.userId);
    setState(() {
      _reloadHistory = [];
    });
  }

  void _confirmDeleteAllHistory() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete all history?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                _deleteAllHistory();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> history) {
    return Card(
      child: ListTile(
        title: Text('RM${history['amount'].toStringAsFixed(2)} reloaded'),
        subtitle: Text(_formatDateTime(history['date'])),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Reload History'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _confirmDeleteAllHistory,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _reloadHistory.isEmpty
            ? Center(child: Text('No reload history found'))
            : ListView.builder(
          itemCount: _reloadHistory.length,
          itemBuilder: (context, index) {
            final history = _reloadHistory[index];
            return _buildHistoryItem(history);
          },
        ),
      ),
    );
  }
}
