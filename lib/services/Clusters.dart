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
bool dengueEnabled = true;

const LatLng DEST_LOCATION = LatLng(1.353195, 103.681082);

///This class is used to display the dengue clusters and to check if the user's current location lies
///within a dengue zone
class Clusters extends StatefulWidget {
  @override
  ClustersState createState() => ClustersState();
}

class ClustersState extends State<Clusters> {
  GoogleMapController _controller;
  Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  Set<Marker> _markers = {};
  Set<Polygon> poly_points = {};
  PolylinePoints polylinePoints = PolylinePoints();
  Position position = Position(latitude: 1.353195, longitude: 103.681082);
  @override

  ///Function to initialize the state of the map and then call `getCurrentLocation`
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  ///Function to get and store the user's current location using `getCurrentPosition` function
  ///from the geolocator package
  getCurrentLocation() async {
    position = await Geolocator().getCurrentPosition();
  }

  ///Display the google map with all the markers, polylines and polygons with the initial camera
  ///position based on the user's current location
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

  ///Function to set the Google Map controller and call `SetPolyLines` and `SetMapPins` to add the
  ///markers and the polylines to the map before display
  void onMapCreated(GoogleMapController controller) {
    _controller = controller;
    setPolylines();
    setMapPins();
  }

  ///Function to add the marker of the user's current location to the list of markers
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

  ///Function to set state and call the `parsingwjson` function
  setPolylines() async {
    setState(() {
      parsingwjson();
    });
  }

  ///Function to read the geojson file which contains the information about all the dengue clusters
  ///After parsing the file, stores the coordinates of each edge point of a cluster in `polylinecoord`
  ///Once all the polylines are created, respective polygons are added to the map before display
  ///`isInPolygon` is used to check if the user's current location lies within a dengue zone, if it does
  ///`showNotification` sends a local notification to the user's device to alert them that they have
  ///entered a dengue zone
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