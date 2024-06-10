import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/vehicle_view_model.dart';
import '../models/vehicle.dart';
import 'parkingduration_page.dart'; // Import the new page

class SelectVehicle extends StatelessWidget {
  final int userId;
  final String parkingLocation;

  SelectVehicle({required this.userId, required this.parkingLocation});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VehicleViewModel()..fetchVehicles(userId),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Select Vehicle'),
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
                      return Card(
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          leading: Icon(Icons.directions_car_sharp, size: 50),
                          title: Text(
                            vehicle.vehiclePlateNum,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          subtitle: Text(vehicle.vehicleName),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ParkingDurationPage(
                                  userId: userId,
                                  selectedVehicle: vehicle,
                                  parkingLocation: parkingLocation,
                                ),
                              ),
                            );
                          },
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
