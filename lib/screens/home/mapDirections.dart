import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapDirections extends StatefulWidget {
  @override
  _MapDirectionsState createState() => _MapDirectionsState();
}

class _MapDirectionsState extends State<MapDirections> {
  GoogleMapController mapController;
  final LatLng _center = const LatLng(45.521563, -122.677433);

  @override
  Widget build(BuildContext context) {
  final double deviceWidth = MediaQuery.of(context).size.width;
  final double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Maps Sample App'),
      ),
      body: Center(
        child: Container(
          height: 2*deviceHeight/3,
          width: deviceWidth-20,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
}
