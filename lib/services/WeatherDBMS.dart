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
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'localNotifications.dart';
/*
Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
}
*/
String key = '9b67a8cad7eeefb08f327ade854f869b';
bool weatherEnabled = true;

void backgroundFetchHeadlessTask(String taskId) async {
  print('[BackgroundFetch] Headless event received.');
  getWeather();
  BackgroundFetch.finish(taskId);
}

Future<Position> getLocation() async {
  Future<Position> position;
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
    String time;
    while (weatherEnabled == true) {
      time = await getWeather();
      if(time != null){
        //Send this push notification when its done
        showNotification(0, "Weather", "Gonna rain in about 2 hours at UTC $time");
        print("Gonna rain at $time");
        sleep(const Duration(hours: 2)); //EDIT THIS
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

void register(){
  BackgroundFetch.start().then((int status) {
    print('[BackgroundFetch] start success: $status');
  }).catchError((e) {
    print('[BackgroundFetch] start FAILURE: $e');
  });
}

void unregister(){
  BackgroundFetch.stop().then((int status) {
    print('[BackgroundFetch] stop success: $status');
  });
}

//Copying simrita

String googleAPIKey = "AIzaSyB9jpG4Ys8xGHf9iyDkbOH3Fz8kB0zaLiI";
const LatLng SG_LOCATION = LatLng(1.3694985, 103.80615239);

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
  BitmapDescriptor rainIcon;
  BitmapDescriptor sunIcon;
  BitmapDescriptor moonIcon;
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

  void onMapCreated(GoogleMapController controller) {
    _controller = controller;
    //_controller.complete(controller);
    setMapPins();
  }


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
        //rain.contains(forecasts[i]["forecast"])
        if (false) {
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
        //forecasts[i]["forecast"].contains("Night")
        else if(false) {
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
