import 'package:firebase_tutorial/shared/baseAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


/// this class contains the UI for displaying a map with a source and a destination,
/// and a line/path connecting the two. This is used by a Responder to view and go towards an alerter's location.
/// It also contains buttons to view youtube tutorials on how to respond, and an option to
/// dial the alerter.
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
      appBar: BaseAppBar(title: 'GO TO ALERTER',),
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
            launchURLButton("Watch tutorial", ()=>_launchURL('https://www.youtube.com/watch?v=TUxusK-X1JU'), Colors.deepOrange[300]),
            launchURLButton("Call alerter", ()=>_launchURL('tel:12345678'),Colors.deepPurple[500]),
          ],
        ),
      ),
    );
  }

  //. UI for button to launch custom URL's
  Widget launchURLButton(text, onPressed, color) {
    return RaisedButton(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(fontSize: 40, color: Colors.white),
        ),
      ),
      color:Colors.red[500],
      shape: new RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
        side: BorderSide(color: Colors.brown, width: 5)
      ),
      onPressed: onPressed,
    );
  }

  /// function which opens specified `url` when invoked.
  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  /// This function is called when the google map is created. 
  /// We set the pins and show the path in this function.
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setMapPins();
    setPolylines();
  }

  //. function to set the responder's and alerter's pins
  void setMapPins() {
    SOURCE_LOCATION = LatLng(widget.sLat, widget.sLng);
    DEST_LOCATION = LatLng(widget.dLat, widget.dLng);
    setState(() {
      // source pin
      _markers.add(Marker(
        markerId: MarkerId('Source'),
        position: SOURCE_LOCATION,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: 'Current Location'),
      ));
      // destination pin
      _markers.add(Marker(
        markerId: MarkerId('Destination'),
        position: DEST_LOCATION,
        infoWindow: InfoWindow(title: 'Alerter Location'),
      ));
    });
  }

  /// function to show the path between the responder and alerter's pins
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
