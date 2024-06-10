import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'selectvehicle_page.dart';

class SelectParkingPage extends StatefulWidget {
  final int userId;

  SelectParkingPage({required this.userId});

  @override
  _SelectParkingPageState createState() => _SelectParkingPageState();
}

class _SelectParkingPageState extends State<SelectParkingPage> {
  final MapController _mapController = MapController();
  LatLng? _selectedLocation;
  LatLng _defaultLocation = LatLng(5.4164, 100.3327); // Default to Penang, Malaysia
  final TextEditingController _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Parking Location'),
      ),
      body: Column(
        children: [
          Container(
            height: 300, // Adjust the height as needed
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    center: _defaultLocation,
                    zoom: 13.0,
                    onTap: (tapPosition, point) {
                      setState(() {
                        _selectedLocation = point;
                        _locationController.text = 'Lat: ${point.latitude}, Lng: ${point.longitude}';
                      });
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                    ),
                    if (_selectedLocation != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _selectedLocation!,
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
                          _mapController.move(_mapController.center, _mapController.zoom + 1);
                        },
                      ),
                      SizedBox(height: 8),
                      FloatingActionButton(
                        heroTag: 'zoomOut',
                        mini: true,
                        child: Icon(Icons.remove),
                        onPressed: () {
                          _mapController.move(_mapController.center, _mapController.zoom - 1);
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
            child: TextField(
              controller: _locationController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Selected Location',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _selectedLocation == null
                  ? null
                  : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectVehicle(
                      userId: widget.userId,
                      parkingLocation: _locationController.text,
                    ),
                  ),
                );
              },
              child: Text('Select this location'),
            ),
          ),
        ],
      ),
    );
  }
}
