import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:park_app/views/parkingduration_page.dart';
import 'selectvehicle_page.dart';
import '../models/vehicle.dart';
import 'package:provider/provider.dart';
import '../viewmodels/select_parking_view_model.dart';
import '../viewmodels/vehicle_view_model.dart';

class SelectParkingPage extends StatelessWidget {
  final int userId;

  SelectParkingPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SelectParkingViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Select Parking Location'),
        ),
        body: Consumer<SelectParkingViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              child: Form(
                key: viewModel.formKey,
                child: Column(
                  children: [
                    Container(
                      height: 300, // Adjust the height as needed
                      child: Stack(
                        children: [
                          FlutterMap(
                            mapController: viewModel.mapController,
                            options: MapOptions(
                              center: viewModel.defaultLocation,
                              zoom: 13.0,
                              onTap: (tapPosition, point) {
                                viewModel.setSelectedLocation(point);
                              },
                            ),
                            children: [
                              TileLayer(
                                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                subdomains: ['a', 'b', 'c'],
                              ),
                              if (viewModel.selectedLocation != null)
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point: viewModel.selectedLocation!,
                                      builder: (ctx) => Container(
                                        child: Icon(Icons.location_on, color: Colors.red, size: 40),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Column(
                              children: [
                                FloatingActionButton(
                                  heroTag: 'zoomIn',
                                  mini: true,
                                  child: Icon(Icons.add),
                                  onPressed: () {
                                    viewModel.zoomIn();
                                  },
                                ),
                                SizedBox(height: 8),
                                FloatingActionButton(
                                  heroTag: 'zoomOut',
                                  mini: true,
                                  child: Icon(Icons.remove),
                                  onPressed: () {
                                    viewModel.zoomOut();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: viewModel.enterLocationController,
                        decoration: InputDecoration(
                          labelText: 'Enter Road',
                          border: OutlineInputBorder(),
                          errorText: viewModel.errorMessage,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Road Name Required';
                          } else if (value.length <= 3) {
                            return 'Road Name must be more than 3 characters';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          viewModel.updateMapLocation();
                        },
                        onChanged: (value) {
                          viewModel.checkIfMoreThanThree(value);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: viewModel.selectedLocation == null
                            ? null
                            : () {
                          if (viewModel.formKey.currentState!.validate()) {
                            _selectVehicle(context, viewModel);
                          } else {
                            viewModel.setErrorMessage('Road Name Required');
                          }
                        },
                        child: Text(
                          'Confirm Location',
                          style: TextStyle(
                            color: viewModel.isMoreThanThree ? Colors.green : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _selectVehicle(BuildContext context, SelectParkingViewModel viewModel) async {
    final selectedVehicle = await showDialog<Vehicle>(
      context: context,
      builder: (context) => VehicleSelectionDialog(userId: userId),
    );

    if (selectedVehicle != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ParkingDurationPage(
            userId: userId,
            selectedVehicle: selectedVehicle,
            parkingLocation: viewModel.locationController.text,
            roadName: viewModel.enterLocationController.text,
          ),
        ),
      );
    }
  }
}

class VehicleSelectionDialog extends StatelessWidget {
  final int userId;

  VehicleSelectionDialog({required this.userId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VehicleViewModel>(
      create: (_) => VehicleViewModel()..fetchVehicles(userId),
      child: Consumer<VehicleViewModel>(
        builder: (context, viewModel, child) {
          return Dialog(
            child: Column(
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
            ),
          );
        },
      ),
    );
  }
}
