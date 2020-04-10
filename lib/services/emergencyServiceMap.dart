import 'package:firebase_tutorial/shared/baseAppBar.dart';
import 'package:firebase_tutorial/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class MyMap extends StatefulWidget {
  // the type of locations to render on the map
  final String type;
  MyMap({this.type});

  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  static String kGoogleApiKey = "AIzaSyB9jpG4Ys8xGHf9iyDkbOH3Fz8kB0zaLiI";
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

  // data we will store
  List<Marker> markers = <Marker>[];
  Position position;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: 'SERVICES : ${widget.type.toUpperCase()}',
      ),
      body: (position == null)
          ? Loading()
          : mapWidget()
    );
  }

  void _getCurrentLocation() async {
    Position res = await Geolocator().getCurrentPosition();
    if (this.mounted) {
      setState(() {
        position = res;
      });
    }
  }

  Widget mapWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      markers: Set<Marker>.of(markers),
      initialCameraPosition: CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 12.0,
      ),
      onMapCreated: (GoogleMapController c) => _onMapCreated(), // same as a function which calls _onMapCreated (fat arrow notation)
    );
  }

  _onMapCreated() {
    print("[info] onMapCreated called");
    // add own location's markr to marker list
    setState(() {
      markers.add(
        Marker(
            markerId: MarkerId('home'),
            position: LatLng(position.latitude, position.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            infoWindow: InfoWindow(title: 'Current Location')),
      );
    });
    addServiceMarkers();
  }

  addServiceMarkers() async {
    print("[info] add service markers called!");
    // get places of needed type using map's places API
    final location = Location(position.latitude, position.longitude);
    final result = await _places.searchNearbyWithRadius(
      location,
      4500,
      type: widget.type,
    );
    print("[info] resultLength : ${result.results.length}");
    for (int i = 0; i < result.results.length; i += 1) {
      setState(() {
        markers.add(
          Marker(
            markerId: MarkerId(result.results[i].placeId),
            position: LatLng(result.results[i].geometry.location.lat,
                result.results[i].geometry.location.lng),
            infoWindow: InfoWindow(
                title: result.results[i].name,
                snippet: result.results[i].vicinity),
            onTap: () {},
          ),
        );
      });
    }
  }
}
