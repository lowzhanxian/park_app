import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/compound_payment_view_model.dart';
import '../models/compound.dart';

class CompoundPaymentPage extends StatelessWidget {
  final int userId;
  final Function onBalanceUpdated;

  CompoundPaymentPage({required this.userId, required this.onBalanceUpdated});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CompoundPaymentViewModel(userId),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pay Compound'),
        ),
        body: Consumer<CompoundPaymentViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.errorMessage != null) {
              return Center(child: Text(viewModel.errorMessage!));
            }

            return ListView(
              children: [
                ListTile(
                  title: Text('Unpaid Compounds'),
                ),
                ...viewModel.compounds.map((compound) => ListTile(
                  title: Text(compound.description),
                  subtitle: Text('RM${compound.amount.toStringAsFixed(2)}'),
                  trailing: ElevatedButton(
                    onPressed: () => _confirmPayment(context, viewModel, compound),
                    child: Text('Pay'),
                  ),
                )),
                Divider(),
                ListTile(
                  title: Text('Paid Compounds'),
                ),
                ...viewModel.paidCompounds.map((compound) => ListTile(
                  title: Text(compound.description),
                  subtitle: Text('RM${compound.amount.toStringAsFixed(2)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Paid on: ${compound.date}'),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _confirmDeletion(context, viewModel, compound),
                      ),
                    ],
                  ),
                )),
              ],
            );
          },
        ),
      ),
    );
  }

  void _confirmPayment(BuildContext context, CompoundPaymentViewModel viewModel, Compound compound) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Payment'),
          content: Text('Are you sure you want to pay for this compound?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                bool success = await viewModel.payCompound(userId, compound);
                _showResultDialog(context, success, 'Compound paid successfully!', viewModel.errorMessage ?? 'Insufficient balance. Please top up your wallet.');
                onBalanceUpdated();
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeletion(BuildContext context, CompoundPaymentViewModel viewModel, Compound compound) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this paid compound?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await viewModel.deletePaidCompound(compound.id!);
                _showResultDialog(context, true, 'Compound deleted successfully!', 'Failed to delete compound.');
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _showResultDialog(BuildContext context, bool success, String successMessage, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(success ? 'Success' : 'Error'),
          content: Text(success ? successMessage : errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
