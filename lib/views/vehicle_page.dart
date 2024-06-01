import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/vehicle_view_model.dart';
import '../models/vehicle.dart';

class VehiclePage extends StatelessWidget {
  final int userId;

  VehiclePage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VehicleViewModel()..fetchVehicles(userId),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Manage Vehicles'),
        ),
        body: Consumer<VehicleViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                if (viewModel.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      viewModel.errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.vehicles.length,
                    itemBuilder: (context, index) {
                      Vehicle vehicle = viewModel.vehicles[index];
                      return ListTile(
                        title: Text(vehicle.vehiclePlateNum),
                        subtitle: Text(vehicle.vehicleName),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                viewModel.vehiclePlateNumController.text = vehicle.vehiclePlateNum;
                                viewModel.vehicleNameController.text = vehicle.vehicleName;
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Edit Vehicle'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: viewModel.vehiclePlateNumController,
                                          decoration: InputDecoration(labelText: 'Vehicle Plate Number'),
                                        ),
                                        TextField(
                                          controller: viewModel.vehicleNameController,
                                          decoration: InputDecoration(labelText: 'Vehicle Name'),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          viewModel.updateVehicle(vehicle);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Save'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                viewModel.deleteVehicle(vehicle.id!, userId);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Add Vehicle'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: viewModel.vehiclePlateNumController,
                                decoration: InputDecoration(labelText: 'Vehicle Plate Number'),
                              ),
                              TextField(
                                controller: viewModel.vehicleNameController,
                                decoration: InputDecoration(labelText: 'Vehicle Name'),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                viewModel.addVehicle(userId);
                                Navigator.of(context).pop();
                              },
                              child: Text('Add'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: Icon(Icons.add),
                    label: Text('Add Vehicle'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
