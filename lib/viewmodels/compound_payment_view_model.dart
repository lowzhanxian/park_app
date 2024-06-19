import 'package:flutter/material.dart';
import '../models/compound.dart';
import '../helpers/database_help.dart';

class CompoundPaymentViewModel extends ChangeNotifier {
  final Db_Helper _dbHelper = Db_Helper();
  List<Compound> compounds = [];
  List<Compound> paidCompounds = [];
  String? errorMessage;

  CompoundPaymentViewModel(int userId) {
    _loadCompounds();
    _loadPaidCompounds(userId);
  }

  Future<void> _loadCompounds() async {
    try {
      compounds = await _dbHelper.getCompounds();
      if (compounds.isEmpty) {
        compounds = [
          Compound(userId: 0, description: "Parking Out Of Line", amount: 20.0, date: ""),
          Compound(userId: 0, description: "Parking At No Line", amount: 30.0, date: ""),
          Compound(userId: 0, description: "No Payment Parking Fee", amount: 40.0, date: ""),
        ];
        for (var compound in compounds) {
          await _dbHelper.insertCompound(compound);
        }
      }
      notifyListeners();
    } catch (e) {
      errorMessage = "Failed to load compounds";
      notifyListeners();
    }
  }

  Future<void> _loadPaidCompounds(int userId) async {
    try {
      paidCompounds = await _dbHelper.getPaidCompounds(userId);
      notifyListeners();
    } catch (e) {
      errorMessage = "Failed to load paid compounds";
      notifyListeners();
    }
  }

  Future<bool> payCompound(int userId, Compound compound) async {
    try {
      double? balance = await _dbHelper.getWalletBalance(userId);
      if (balance != null && balance >= compound.amount) {
        await _dbHelper.updateWalletBalance(userId, balance - compound.amount);
        compound.userId = userId;
        compound.date = DateTime.now().toIso8601String();
        await _dbHelper.insertPaidCompound(compound);
        compounds.remove(compound);
        paidCompounds.add(compound);
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      errorMessage = "Failed to process payment";
      notifyListeners();
      return false;
    }
  }
  Future<void> deletePaidCompound(int id) async {
    try {
      await _dbHelper.deletePaidCompound(id);
      paidCompounds.removeWhere((compound) => compound.id == id);
      notifyListeners();
    } catch (e) {
      errorMessage = "Failed to delete paid compound";
      notifyListeners();
    }
  }
}
