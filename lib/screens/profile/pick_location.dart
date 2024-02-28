// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:convert';

import 'package:ai_match_making_app/screens/profile/location_map_page.dart';
import 'package:ai_match_making_app/screens/profile/setting_schedule.dart';
import 'package:ai_match_making_app/utils/constants.dart';
import 'package:ai_match_making_app/utils/conversion.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PickLocation extends StatefulWidget {
  @override
  _PickLocationState createState() => _PickLocationState();
}

class _PickLocationState extends State<PickLocation> {
  final TextEditingController _searchController = TextEditingController();
  List<Prediction> _searchResults = [];

  var selectedAddress;

  Future<void> _onSearchTextChanged(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults.clear();
      });
      return;
    }

    final api = apiKey;
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&types=address&components=country:JP&key=$api';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final predictions = jsonDecode(response.body)['predictions'] as List;
      setState(() {
        _searchResults = predictions
            .map((prediction) => Prediction.fromJson(prediction))
            .toList();
      });
    } else {
      setState(() {
        _searchResults.clear();
      });
    }
  }

  Future<void> _handleLocationSelection(Prediction prediction) async {
    _searchController.text = prediction.description; // Update search text
    // Navigator.pop(context, _searchController.text);
    selectedAddress = _searchController.text;
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) =>
          LocationMapPage(selectedLocation: selectedAddress),
    );
    // Handle the result returned from LocationMapPage if needed
    if (result != null) {
      // Handle the marker details received from LocationMapPage
      // You can store or display the details as needed
      Navigator.pop(context, result);
    }
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final prediction = _searchResults[index];
        return ListTile(
          leading: Icon(Icons.location_on),
          title: Text(prediction.description),
          onTap: () => _handleLocationSelection(prediction),
        );
      },
    );
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
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: settingSchedule['pleaseEnterAdd']!,
                prefixIcon: Icon(Icons.search), // Add search icon
                filled: true, // Enable filling the background
                fillColor: Colors.grey[300], // Set the background color to grey
              ),
              onChanged: _onSearchTextChanged,
            ),
          ),
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }
}

class Prediction {
  final String placeId;
  final String description;

  Prediction({
    required this.placeId,
    required this.description,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      placeId: json['place_id'],
      description: json['description'],
    );
  }
}
