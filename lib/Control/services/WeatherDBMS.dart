import 'dart:async';
import 'dart:io';
import 'package:background_fetch/background_fetch.dart';
import 'package:firebase_tutorial/shared/baseAppBar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'localNotifications.dart';

/// This class checks if it will be raining in 2 hours and displays the weather map
/// It fetches weather information from OpenWeatherMap
/// Checks if it will rain in 2 hours at the user's location
/// If it will, the user will get a notification
/// Background Fetch is used to ensure the weather checking process keeps running after the app is terminated
/// It will check every 15 minutes or so. If it checks that it rains, then it will stop checking for about 2 hours

/// [key] is the api key from OpenWeatherMap used to fetch weather data
String key = '9b67a8cad7eeefb08f327ade854f869b';
/// [weatherEnabled] checks if the user agrees to receive notifications on weather
bool weatherEnabled = true;

/// Background Fetch executes the [getWeather()] regardless of whether the app is opened on the user's device
void backgroundFetchHeadlessTask(String taskId) async {
  print('[BackgroundFetch] Headless event received.');
  getWeather();
  BackgroundFetch.finish(taskId);
}

/// Checks if the user gives the app access to information on the current location of the user
/// Returns the current location of the user
Future<Position> getLocation() async {
  Future<Position> position;
  PermissionStatus permission = await PermissionHandler()
      .checkPermissionStatus(PermissionGroup.location);

  if (permission == PermissionStatus.denied) {
    await PermissionHandler()
        .requestPermissions([PermissionGroup.locationAlways]);
  }

  var geolocator = Geolocator();

  /// checks if the user allows the app to receive information on their location
  GeolocationStatus geolocationStatus =
  await geolocator.checkGeolocationPermissionStatus();

  switch (geolocationStatus) {
    case GeolocationStatus.denied:
      print('denied');
      break;
    case GeolocationStatus.disabled:
      print('disabled');
      break;
    case GeolocationStatus.restricted:
      print('restricted');
      break;
    case GeolocationStatus.unknown:
      print('unknown');
      break;
    case GeolocationStatus.granted:
      print('Access granted');
      position = _getCurrentLocation();
  }
  return position;
}
/// Returns the current location of the user
Future<Position> _getCurrentLocation() async {
  Position position;
  do {
    Position res = await Geolocator().getCurrentPosition();
    position = res;
    print("position is $position");
    sleep(Duration(seconds: 5));
  } while (position == null);
  return position;
}
/// Based on the user's location, fetch the weather information from OpenWeatherMap
/// Returns weather information with regards to the user's current position in 2 hours time
Future<Map> getData() async {
  //await Future.delayed(Duration(seconds: 5)); //Mock delay
  Position position;
  do{position = await getLocation(); await Future.delayed(Duration(seconds: 1));}while(position==null);
  print("get Data $position");
  String apiUrl ="http://api.openweathermap.org/data/2.5/forecast?lat=${position.latitude}&lon=${position.longitude}&appid=$key&units=metric";
  print(apiUrl);
  http.Response response = await http.get(apiUrl);
  Map content = json.decode(response.body);
  print(content.toString());
  return content['list'][0];
}

/// Checks if the weather in 2 hours at the user's location is going to rain
/// if it is, the date and time of the predicted rain will be returned, else return null
Future<String> getWeather() async{
  Map future = await getData();
  print("Created the stream");
  print(future);
  if(future['weather'][0]['main'] == "Rain"){
    print("It might rain at ${future['dt_txt'].toString()}");
    return future['dt_txt'].toString();
  }else{
    return null;
  }
}

/// Initialises the Background fetch for the weather checking process
Future<void> initPlatformState() async {
  // Configure BackgroundFetch.
  BackgroundFetch.configure(BackgroundFetchConfig(
      minimumFetchInterval: 15,
      stopOnTerminate: false,
      enableHeadless: true,
      requiresBatteryNotLow: false,
      requiresCharging: false,
      requiresStorageNotLow: false,
      requiresDeviceIdle: false,
      requiredNetworkType: NetworkType.NONE
  ), (String taskId) async {
    // This is the fetch-event callback.
    print("[BackgroundFetch] Event received $taskId");
    //showNotification(0, "BEANS", "Event received");
    // IMPORTANT:  You must signal completion of your task or the OS can punish your app
    // for taking too long in the background.
    // Checks the weather and shows notification if it is going to rain in 2 hours at the user's current location
    // Here the main code to be executed for background fetch
    String time;
    while (weatherEnabled == true) {
      time = await getWeather();
      if(time != null){
        //Send this push notification
        showNotification(0, "Alert", "It is going to rain in about 2 hours at your current location");
        print("Gonna rain at $time");
        sleep(const Duration(hours: 2));
      }
      sleep(const Duration(minutes: 5));
    }
    BackgroundFetch.finish(taskId);
  }).then((int status) {
    print('[BackgroundFetch] configure success: $status');
  }).catchError((e) {
    print('[BackgroundFetch] configure ERROR: $e');
  });
}

/// starts the background fetch process
void register(){
  BackgroundFetch.start().then((int status) {
    print('[BackgroundFetch] start success: $status');
  }).catchError((e) {
    print('[BackgroundFetch] start FAILURE: $e');
  });
}

/// stops the background fetch
void unregister(){
  BackgroundFetch.stop().then((int status) {
    print('[BackgroundFetch] stop success: $status');
  });
}

// WEATHER MAP Portion

/// [googleAPIKey] is the api key for google maps
String googleAPIKey = "AIzaSyB9jpG4Ys8xGHf9iyDkbOH3Fz8kB0zaLiI";
/// coordinates of Singapore, for the map to open up at Singapore
const LatLng SG_LOCATION = LatLng(1.3694985, 103.80615239);
/// This class displays the Weather Map
class Weather extends StatefulWidget {
  @override
  WeatherState createState() => WeatherState();
}

class WeatherState extends State<Weather> {
  GoogleMapController _controller;
  Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  List<LatLng> polygonlinecoord = [];
  Set<Marker> _markers = {};
  Set<Polygon> poly_points = {};
  PolylinePoints polylinePoints = PolylinePoints();
  Position position;
  BitmapDescriptor rainIcon; // have to change size of input image if the icon displayed is too big/small
  BitmapDescriptor sunIcon; // the images are found in assets folder as usual
  BitmapDescriptor moonIcon; // Remember to add into pubspecyaml

  /// Retrieve the icons for the map here so that it can be ready when the map opens up
  @override
  void initState() {
    super.initState();
    //showNotification(0, "BEANS", "Initialise");
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(48, 48)), 'assets/rain.png')
        .then((onValue) {
      rainIcon = onValue;
    });
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(48, 48)), 'assets/sunny.png')
        .then((onValue) {
      sunIcon = onValue;
    });
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(48, 48)), 'assets/moon.png')
        .then((onValue) {
      moonIcon = onValue;
    });
  }

  /// get Current location of user then set [position] to the current user location
  getCurrentLocation() async {
    position = await Geolocator().getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(title: "WEATHER MAP"),
      body: GoogleMap(
          myLocationEnabled: true,
          compassEnabled: true,
          tiltGesturesEnabled: false,
          markers: _markers,
          polylines: _polylines,
          polygons: poly_points,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(SG_LOCATION.latitude, SG_LOCATION.longitude),
            zoom: 10.0,
          ),
          onMapCreated: onMapCreated),
    );
  }
/// set Map Pins when the map is created
  void onMapCreated(GoogleMapController controller) {
    _controller = controller;
    //_controller.complete(controller);
    setMapPins();
  }

  /// Check with data.gov.sg for 2 hours weather forecast
  /// add to [_markers] the rain/sunny/moon icon markers at each location in the weather data depending on the forecasted weather
  void setMapPins() async {
    //await Future.delayed(Duration(seconds: 5)); //Mock delay
    String apiUrl = "https://api.data.gov.sg/v1/environment/2-hour-weather-forecast";
    print(apiUrl);
    http.Response response = await http.get(apiUrl);
    int statusCode = response.statusCode;
    print(statusCode);
    Map content = json.decode(response.body);
    //print(content);
    List location = content["area_metadata"];
    List forecasts = content["items"][0]["forecasts"];
    print(forecasts[1]["area"]);
    List<String> rain = ["Showers","Thundery Showers","Heavy Thundery Showers","Moderate Rain","Light Rain","Heavy Thundery Showers with Gusty Winds"];

    setState(() {
      if(position != null){
        print("Home Marker");
        _markers.add(Marker(
          markerId: MarkerId('home'),
          position: LatLng(position.latitude, position.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ));
      }
      for (var i = 0; i < forecasts.length; i++) {
        // put Raining Icons
        if (rain.contains(forecasts[i]["forecast"])) {
          print("Raining");
          _markers.add(Marker(
            markerId: MarkerId(location[i]["name"]),
            position: LatLng(location[i]["label_location"]["latitude"],
                location[i]["label_location"]["longitude"]),
            icon: rainIcon,
            infoWindow: InfoWindow(
              title: forecasts[i]["forecast"],
            ),
          ));
        }
        // Put moon icons
        else if(forecasts[i]["forecast"].contains("Night")) {
          _markers.add(Marker(
            markerId: MarkerId(location[i]["name"]),
            position: LatLng(location[i]["label_location"]["latitude"],
                location[i]["label_location"]["longitude"]),
            icon: moonIcon,
            infoWindow: InfoWindow(
              title: forecasts[i]["forecast"],
            ),
          ));
        }
        // Put Sun Icons
        else{
          _markers.add(Marker(
            markerId: MarkerId(location[i]["name"]),
            position: LatLng(location[i]["label_location"]["latitude"],
                location[i]["label_location"]["longitude"]),
            icon: sunIcon,
            infoWindow: InfoWindow(
              title: forecasts[i]["forecast"],
            ),
          ));
        }
      }
    });
  }
}