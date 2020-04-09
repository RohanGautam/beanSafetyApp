import 'dart:async';
import 'package:firebase_tutorial/services/WeatherDBMS.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_map_polyline/google_map_polyline.dart';

const kGoogleApiKey = "AIzaSyB9jpG4Ys8xGHf9iyDkbOH3Fz8kB0zaLiI";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

List<Marker> markers = <Marker>[];

class MyMap extends StatefulWidget {
  final type;
  MyMap({this.type}) : super(key: UniqueKey());

  //First override
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  GoogleMapController _controller;

  List<LatLng> routeCoords;
  GoogleMapPolyline googleMapPolyline =
      new GoogleMapPolyline(apiKey: "AIzaSyB9jpG4Ys8xGHf9iyDkbOH3Fz8kB0zaLiI");

  Position position;
  Widget _child;

  void showToast(message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<void> getLocation() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);

    if (permission == PermissionStatus.denied) {
      await PermissionHandler()
          .requestPermissions([PermissionGroup.locationAlways]);
    }

    var geolocator = Geolocator();

    GeolocationStatus geolocationStatus =
        await geolocator.checkGeolocationPermissionStatus();

    switch (geolocationStatus) {
      case GeolocationStatus.denied:
        showToast('denied');
        break;
      case GeolocationStatus.disabled:
        showToast('disabled');
        break;
      case GeolocationStatus.restricted:
        showToast('restricted');
        break;
      case GeolocationStatus.unknown:
        showToast('unknown');
        break;
      case GeolocationStatus.granted:
        showToast('Access granted');
        _getCurrentLocation();
    }
  }

  void _setStyle(GoogleMapController controller) async {
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    controller.setMapStyle(value);
  }

  //Second override
  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void _getCurrentLocation() async {
    Position res = await Geolocator().getCurrentPosition();
    if (this.mounted) {
      setState(() {
        position = res;
        _child = _mapWidget();
      });
    }
  }

  Widget _mapWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      markers: Set<Marker>.of(markers),
      initialCameraPosition: CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 12.0,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller = controller;
        // _setStyle(controller);
      },
    );
  }

  //3rd override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            initialMarker();
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.red[400],
        title: Text(
          'Google Map',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
              padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 0),
              alignment: Alignment.center,
              height: 450,
              child: _child),
          SizedBox(
            height: 2,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          searchNearby(position);
          setState(() {
            _getCurrentLocation();
          });
          // 2
        },
        label: Text('Places Nearby'), // 3
        icon: Icon(Icons.place),
        // 4
      ),
    );
  }

  void initialMarker() {
    markers = [];
    markers.add(Marker(
        markerId: MarkerId('home'),
        position: LatLng(position.latitude, position.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: 'Current Location')));
  }

  void searchNearby(Position position) async {
    initialMarker();
    final location = Location(position.latitude, position.longitude);
    final result = await _places.searchNearbyWithRadius(
      location,
      2500,
      type: widget.type,
    );

    for (int i = 0; i < result.results.length; i++) {
      print(
          "${result.results[i].geometry.location.lat}, ${result.results[i].geometry.location.lng}");
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
