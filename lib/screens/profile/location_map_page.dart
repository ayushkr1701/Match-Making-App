// ignore_for_file: prefer_const_constructors

import 'package:ai_match_making_app/screens/profile/setting_schedule.dart';
import 'package:ai_match_making_app/utils/conversion.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationMapPage extends StatefulWidget {
  final String selectedLocation;

  LocationMapPage({required this.selectedLocation});

  @override
  _LocationMapPageState createState() => _LocationMapPageState();
}

class _LocationMapPageState extends State<LocationMapPage> {
  late GoogleMapController _mapController;
  LatLng _markerPosition = LatLng(0, 0);
  String _address = '';

  @override
  void initState() {
    super.initState();
    // Set initial marker position to the selected location
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setMarkerPosition(widget.selectedLocation);
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _setMarkerPosition(String location) async {
    try {
      List<Location> locations = await locationFromAddress(location);
      if (locations.isNotEmpty) {
        // Get the first location result
        Location result = locations.first;
        // Set the marker position
        setState(() {
          _markerPosition = LatLng(result.latitude, result.longitude);
        });
        // Move the camera to the marker position
        _mapController.animateCamera(CameraUpdate.newLatLng(_markerPosition));
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _onMarkerDragEnd(LatLng newPosition) async {
    setState(() {
      _markerPosition = newPosition;
    });

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        newPosition.latitude,
        newPosition.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        setState(() {
          _address = placemark.name ?? '';
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _locateMarker() {
    var markerDetails = {
      'address': _address,
      'latitude': _markerPosition.latitude,
      'longitude': _markerPosition.longitude,
    };
    Navigator.pop(context, markerDetails);
  }

  void _printAddress() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _markerPosition.latitude,
        _markerPosition.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        String name = placemark.name ?? '';
        String? street = placemark.street;
        String sublocality = placemark.subLocality ?? '';
        String locality = placemark.locality ?? '';
        String postalcode = placemark.postalCode ?? '';
        _address = '$name , $street, $sublocality, $locality, $postalcode';
        print(_address);
        var markerDetails = {
        'street': street,
        'prefecture': '$sublocality, $locality',
        'pincode': postalcode,
        'address': _address,
        'latitude': (_markerPosition.latitude).toDouble(),
        'longitude': _markerPosition.longitude,
      };
        Navigator.pop(context, markerDetails);
      } else {
        print('No address found for the selected location.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          settingSchedule['findAnAdd']!,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, // Set the color of the back button icon
        ),
        leading: IconButton(
          icon: Icon(Icons.close), // Set the icon to 'close'
          onPressed: () {
            Navigator.pop(context); // Go back when the button is pressed
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 220.0,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _markerPosition,
                zoom: 15.0,
              ),
              markers: {
                Marker(
                  markerId: MarkerId('selectedLocationMarker'),
                  position: _markerPosition,
                  draggable: true,
                  onDragEnd: _onMarkerDragEnd,
                ),
              },
              onCameraMove: (CameraPosition cameraPosition) {
                setState(() {
                  _markerPosition = cameraPosition.target;
                });
              },
            ),
          ),
          Positioned(
            left: 16.0,
            right: 16.0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color.fromRGBO(17, 86, 149, 1),
                    width: 2,
                  ),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(17, 86, 149, 1),
                  ),
                  onPressed: () {
                    _printAddress();
                  },
                  child: Text(
                    settingSchedule['locateIt']!,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
