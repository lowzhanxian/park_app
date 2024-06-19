import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/parking_details_view_model.dart';
import '../models/parking_details.dart';

class ParkingHistoryPage extends StatelessWidget {
  final int userId;

  ParkingHistoryPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ParkingHistoryViewModel()..fetchParkingHistory(userId),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Parking History'),
        ),
        body: Consumer<ParkingHistoryViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.errorMessage != null) {
              return Center(child: Text(viewModel.errorMessage!));
            }

            return ListView.builder(
              itemCount: viewModel.parkingHistory.length,
              itemBuilder: (context, index) {
                ParkingDetails parking = viewModel.parkingHistory[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text('Location: ${parking.parkingLocation}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Road Name: ${parking.roadName}'),
                        Text('Vehicle: ${parking.vehiclePlateNum}'),
                        Text('Date: ${parking.date}'),
                        Text('Duration: ${parking.duration} hours'),
                        Text('Total Price: RM${parking.totalPrice.toStringAsFixed(2)}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _confirmDelete(context, viewModel, parking.id!, userId);
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, ParkingHistoryViewModel viewModel, int id, int userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this record?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                viewModel.deleteParkingRecord(id, userId);
              },
            ),
          ],
        );
      },
    );
  }
}
