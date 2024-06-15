import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class SelectParkingViewModel extends ChangeNotifier {
  final MapController mapController = MapController();
  LatLng? selectedLocation;
  LatLng defaultLocation = LatLng(5.4164, 100.3327); // Default to Penang, Malaysia
  final TextEditingController locationController = TextEditingController();
  final TextEditingController enterLocationController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? errorMessage;
  bool isMoreThanThree = false;

  void setSelectedLocation(LatLng point) {
    selectedLocation = point;
    locationController.text = 'Lat: ${point.latitude}, Lng: ${point.longitude}';
    mapController.move(point, 13.0);
    notifyListeners();
  }

  void zoomIn() {
    mapController.move(mapController.center, mapController.zoom + 1);
    notifyListeners();
  }

  void zoomOut() {
    mapController.move(mapController.center, mapController.zoom - 1);
    notifyListeners();
  }

  void updateMapLocation() {
    if (formKey.currentState!.validate()) {
      final input = enterLocationController.text;
      final coordinates = input.split(',');

      if (coordinates.length == 2) {
        final lat = double.tryParse(coordinates[0].trim());
        final lng = double.tryParse(coordinates[1].trim());

        if (lat != null && lng != null) {
          final newLocation = LatLng(lat, lng);
          setSelectedLocation(newLocation);
          setErrorMessage('Location updated successfully');
        } else {
          setErrorMessage('Invalid coordinates. Please enter valid latitude and longitude.');
        }
      } else {
        setErrorMessage('Invalid format. Please enter coordinates as "lat, lng".');
      }
    } else {
      setErrorMessage('Please enter a road name');
    }
  }

  void setErrorMessage(String? message) {
    errorMessage = message;
    notifyListeners();
  }

  void checkIfMoreThanThree(String value) {
    if (value.length > 3) {
      isMoreThanThree = true;
    } else {
      isMoreThanThree = false;
    }
    notifyListeners();
  }
}
