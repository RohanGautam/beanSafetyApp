import 'package:firebase_tutorial/Widget/BaseAppBar.dart';
import 'package:firebase_tutorial/Widget/LoadingScreen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

/// This class returns a map screen, of a specific `type`.
/// The `type` can be "pharmacy", "hospital", or "police" in our case.
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

  /// initially get the current location of the user.
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  /// Show a loading screen while the user location is being fetched.
  /// once we have the `position`, we can show the map.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppBar(
          title: 'SERVICES : ${widget.type.toUpperCase()}',
        ),
        body: (position == null) ? Loading() : mapWidget());
  }

  void _getCurrentLocation() async {
    Position res = await Geolocator().getCurrentPosition();
    if (this.mounted) {
      setState(() {
        position = res;
      });
    }
  }

  /// The google map, which will occupy the whole screen
  Widget mapWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      markers: Set<Marker>.of(markers),
      initialCameraPosition: CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 12.0,
      ),
      onMapCreated: (GoogleMapController c) =>
          _onMapCreated(), // same as a function which calls _onMapCreated (fat arrow notation)
    );
  }

  /// called when the google map is created.
  /// Adds the pin for the users current location on the map.
  /// Also, calls `addServiceMarkers` to add surrouding pins for the reuired service.
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

  /// uses the Google maps places API to fetch nearby locations of desired type.
  /// It then plots these as markers on the map.
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
