import 'dart:convert';
import 'package:firebase_tutorial/shared/baseAppBar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_map_polyutil/google_map_polyutil.dart';

import 'localNotifications.dart';

String googleAPIKey = "AIzaSyB9jpG4Ys8xGHf9iyDkbOH3Fz8kB0zaLiI";
// for my custom icons
BitmapDescriptor sourceIcon;
BitmapDescriptor destinationIcon;

const LatLng DEST_LOCATION = LatLng(1.353195, 103.681082);

class DengueDBMS extends StatefulWidget {
  @override
  DengueDBMSState createState() => DengueDBMSState();
}

class DengueDBMSState extends State<DengueDBMS> {
  GoogleMapController _controller;
  Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  Set<Marker> _markers = {};
  Set<Polygon> poly_points = {};
  PolylinePoints polylinePoints = PolylinePoints();
  Position position = Position(latitude: 1.353195, longitude: 103.681082);
  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  getCurrentLocation() async {
    position = await Geolocator().getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: "DENGUE CLUSTERS",
      ),
      body: GoogleMap(
          myLocationEnabled: true,
          compassEnabled: true,
          tiltGesturesEnabled: false,
          markers: _markers,
          polylines: _polylines,
          polygons: poly_points,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 12.0,
          ),
          onMapCreated: onMapCreated),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    _controller = controller;
    setPolylines();
    setMapPins();
  }

  void setMapPins() {
    setState(() {
      // source pin
      _markers.add(Marker(
        markerId: MarkerId('current location'),
        position: LatLng(position.latitude, position.longitude),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  setPolylines() async {
    List<PointLatLng> result = await polylinePoints?.getRouteBetweenCoordinates(
        googleAPIKey,
        position.latitude,
        position.longitude,
        DEST_LOCATION.latitude,
        DEST_LOCATION.longitude);
    if (result.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      result.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    setState(() {
      // create a Polyline instance
      // with an id, an RGB color and the list of LatLng pairs
      Polyline polyline = Polyline(
          polylineId: PolylineId("poly"),
          color: Color.fromARGB(255, 40, 122, 198),
          points: polylineCoordinates);

      // add the constructed polyline as a set of points
      // to the polyline set, which will eventually
      // end up showing up on the map
      // _polylines.add(polyline);
      parsingwjson();
    });
  }

  parsingwjson() async {
    List dummy_data = [];
    bool isInPolygon;
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/dengue-clusters-geojson.geojson");
    final jsonResult = json.decode(data);
    dummy_data = jsonResult["features"][0]["geometry"]["coordinates"];
    print('the data parsed is as follows');
    print(jsonResult["features"][0]["geometry"]["coordinates"][0][0]);
    for (int j = 0; j < jsonResult["features"].length; j++) {
      List<LatLng> polygonlinecoord = [];
      isInPolygon = false;
      for (int i = 0;
          i < (jsonResult["features"][j]["geometry"]["coordinates"][0]).length;
          i++) {
        polygonlinecoord.add(LatLng(
            jsonResult["features"][j]["geometry"]["coordinates"][0][i][1],
            jsonResult["features"][j]["geometry"]["coordinates"][0][i][0]));
      }
      setState(() {
        poly_points.add(Polygon(
            polygonId: PolygonId("cluster $j"),
            fillColor: Colors.red[100],
            points: polygonlinecoord,
            strokeColor: Colors.red[300],
            strokeWidth: 5));
      });
    }
    print("Now checking if point lies within any cluster: ");
    for (int j = 0; j < jsonResult["features"].length; j++) {
      List<LatLng> polygonlinecoord = [];
      isInPolygon = false;
      for (int i = 0;
          i < (jsonResult["features"][j]["geometry"]["coordinates"][0]).length;
          i++) {
        polygonlinecoord.add(LatLng(
            jsonResult["features"][j]["geometry"]["coordinates"][0][i][1],
            jsonResult["features"][j]["geometry"]["coordinates"][0][i][0]));
      }
      //to check if containslocation works run below commented line: output will be true, because i have fed in a point that lies within the cluster
      //isInPolygon = await GoogleMapPolyUtil.containsLocation(point: LatLng(1.314530, 103.878397), polygon: polygonlinecoord);
      isInPolygon = await GoogleMapPolyUtil.containsLocation(
          point: LatLng(position.latitude, position.longitude),
          polygon: polygonlinecoord);
      if (isInPolygon == true) {
        showNotification(1, "Alert", "You are now in the dengue area");
        print("For cluster $j you lie in the dengue area");
      }
    }
    print("End of checking process");
  }
}
