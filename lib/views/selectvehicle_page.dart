import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/vehicle_view_model.dart';
import '../models/vehicle.dart';

class VehicleSelectionDialog extends StatelessWidget {
  final int userId;

  VehicleSelectionDialog({required this.userId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VehicleViewModel>(
      create: (_) => VehicleViewModel()..fetchVehicles(userId),
      child: Dialog(
        child: Consumer<VehicleViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (viewModel.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      viewModel.errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                if (viewModel.vehicles.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('No vehicles available.'),
                  ),
                if (viewModel.vehicles.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: viewModel.vehicles.length,
                    itemBuilder: (context, index) {
                      Vehicle vehicle = viewModel.vehicles[index];
                      return ListTile(
                        leading: Icon(Icons.directions_car_sharp, size: 40),
                        title: Text(
                          vehicle.vehiclePlateNum,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(vehicle.vehicleName),
                        onTap: () {
                          Navigator.pop(context, vehicle);
                        },
                      );
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
