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
          title: Text('Your Vehicles'),
        ),
        body: Consumer<VehicleViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      //showing dialog
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
                            ElevatedButton(
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
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                if (viewModel.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      viewModel.errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.all(10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: viewModel.vehicles.length,
                    itemBuilder: (context, index) {
                      Vehicle vehicle = viewModel.vehicles[index];
                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: InkWell(
                          onTap: () {
                            // Handle on tap if needed
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.directions_car_sharp, size: 50, color: Colors.blue),
                              SizedBox(height: 10),
                              Text(
                                vehicle.vehiclePlateNum,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                              ),
                              Text(
                                vehicle.vehicleName,
                                style: TextStyle(fontSize: 14.0),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.orange),
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
                                            ElevatedButton(
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
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('Confirm Delete'),
                                          content: Text('Are you sure you want to delete this vehicle?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Cancel'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                viewModel.deleteVehicle(vehicle.id!, userId);
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Delete'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
