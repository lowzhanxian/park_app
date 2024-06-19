import 'package:flutter/material.dart';
import '../helpers/database_help.dart';
import '../models/parking_details.dart';

class ParkingHistoryViewModel extends ChangeNotifier {
  final Db_Helper _dbHelper = Db_Helper();
  List<ParkingDetails> parkingHistory = [];
  String? errorMessage;

  Future<void> fetchParkingHistory(int userId) async {
    try {
      parkingHistory = await _dbHelper.getParkingHistory(userId);
      errorMessage = null;
    } catch (e) {
      errorMessage = 'Error fetching parking history: $e';
    }
    notifyListeners();
  }

  Future<void> deleteParkingRecord(int id, int userId) async {
    try {
      await _dbHelper.deleteParkingDetail(id);
      await fetchParkingHistory(userId);
      errorMessage = null;
    } catch (e) {
      errorMessage = 'Error deleting parking record: $e';
    }
    notifyListeners();
  }
}
