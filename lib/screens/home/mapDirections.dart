import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MapDirections extends StatefulWidget {
  final sLat;
  final sLng;
  final dLat;
  final dLng;

  MapDirections({this.sLat, this.sLng, this.dLat, this.dLng});

  @override
  _MapDirectionsState createState() => _MapDirectionsState();
}

class _MapDirectionsState extends State<MapDirections> {
  GoogleMapController mapController;
  final LatLng _center = const LatLng(37.4219983, -122.084);
  LatLng
      SOURCE_LOCATION; // =  LatLng(double.parse(widget.sLat), double.parse(widget.sLng));
  LatLng DEST_LOCATION; //= const LatLng(45.621563, -122.777433);
// this will hold the generated pconstolylines
  Set<Marker> _markers = {};
  // this will hold each polyline coordinate as Lat and Lng pairs
  Set<Polyline> _polylines = {};
  // this is the key object - the PolylinePoints
  // which generates every polyline between start and finish
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPIKey = "AIzaSyDzlU-E08LKe0uKieMHG68ZWCsPcC8z0VA";

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Maps Sample App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              height: 2 * deviceHeight / 3,
              width: deviceWidth - 20,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: true,
                  markers: _markers,
                  polylines: _polylines,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 11.0,
                  ),
                ),
              ),
            ),
            launchURLButton("Watch tutorial", _launchURL, Colors.deepOrange[300]),
            launchURLButton("Call alerter", _launchTelephoneURL,Colors.deepPurple[500]),
          ],
        ),
      ),
    );
  }

  Widget launchURLButton(text, onPressed, color) {
    return RaisedButton(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(fontSize: 40, color: Colors.white),
        ),
      ),
      color: color,
      shape: new RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
      onPressed: onPressed,
    );
  }

  _launchURL() async {
    const url = 'https://www.youtube.com/watch?v=TUxusK-X1JU';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchTelephoneURL() async {
    const url = 'tel:12345678';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setMapPins();
    setPolylines();
  }

  void setMapPins() {
    SOURCE_LOCATION = LatLng(widget.sLat, widget.sLng);
    DEST_LOCATION = LatLng(widget.dLat, widget.dLng);
    setState(() {
      // source pin
      _markers.add(Marker(
        markerId: MarkerId('Source'),
        position: SOURCE_LOCATION,
      ));
      // destination pin
      _markers.add(Marker(
        markerId: MarkerId('Destination'),
        position: DEST_LOCATION,
      ));
    });
  }

  setPolylines() async {
    List<PointLatLng> result = await polylinePoints?.getRouteBetweenCoordinates(
        googleAPIKey,
        SOURCE_LOCATION.latitude,
        SOURCE_LOCATION.longitude,
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
      _polylines.add(polyline);
    });
  }
}
