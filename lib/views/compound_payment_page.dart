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
          title: Text('Your Compounds'),
        ),

        body: Consumer<CompoundPaymentViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.errorMessage != null) {
              return Center(child: Text(viewModel.errorMessage!));
            }
            return
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Ongoing Compounds', style: TextStyle(fontSize: 20,color: Colors.red,),
                  ),

                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: viewModel.compounds.length,
                      itemBuilder: (context, index) {
                        Compound compound = viewModel.compounds[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 10),//margin between
                          child: ListTile(
                            title: Text(compound.description),
                            subtitle: Text('RM${compound.amount.toStringAsFixed(2)}'),
                            trailing: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              ),
                              onPressed: () => _confirmPayment(context, viewModel, compound),
                              child: Text(
                                'Pay',
                                style: TextStyle(fontSize: 20, color: Colors.red),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Paid Compounds',
                      style: TextStyle(color: Colors.green,fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: viewModel.paidCompounds.length,
                      itemBuilder: (context, index) {
                        Compound compound = viewModel.paidCompounds[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            title: Text(compound.description),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('RM${compound.amount.toStringAsFixed(2)}',),
                                Text('Paid on: ${compound.date}'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete,color: Colors.red,size: 30,),
                              onPressed: () => _confirmDeletion(context, viewModel, compound),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
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
          content: Text('Are you sure you want to pay this compound?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                bool success = await viewModel.payCompound(userId, compound);
                _showResultDialog(context, success, 'Payment Successful!', viewModel.errorMessage ?? 'Not Enough Balance in Wallet');
                onBalanceUpdated();
              },
              child: Text('Pay'),
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
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await viewModel.deletePaidCompound(compound.id!);
                _showResultDialog(context, true, 'Compound deleted successfully!', 'Failed to delete compound.');
              },
              child: Text('Delete'),
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
