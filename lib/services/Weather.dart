import 'dart:async';
import 'dart:io';
import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
//import 'package:hello_world/AlertMeUI.dart' as alert;
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

String key = '9b67a8cad7eeefb08f327ade854f869b';

void backgroundFetchHeadlessTask(String taskId) async {
  print('[BackgroundFetch] Headless event received.');
  getWeather();
  BackgroundFetch.finish(taskId);
}

Future<Position> getLocation() async {
  Future<Position> position;
  PermissionStatus permission =
  await PermissionHandler().checkPermissionStatus(PermissionGroup.location);

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
  do {
    position = await getLocation();
    await Future.delayed(Duration(seconds: 1));
  } while (position == null);
  print("get Data $position");
  String apiUrl =
      "http://api.openweathermap.org/data/2.5/forecast?lat=${position.latitude}&lon=${position.longitude}&appid=$key&units=metric";
  print(apiUrl);
  http.Response response = await http.get(apiUrl);
  Map content = json.decode(response.body);
  print(content.toString());
  return content['list'][3];
}

Future<String> getWeather() async {
  Map future = await getData();
  print("Created the stream");
  print(future);
  if (future['weather'][0]['main'] == "Rain") {
    print("It might rain at ${future['dt_txt'].toString()}");
    return future['dt_txt'].toString();
  } else {
    return null;
  }
}

void main() {
  //runApp(WeatherDBMS());
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

class WeatherDBMS extends StatefulWidget {
  @override
  WeatherDBMSState createState() => WeatherDBMSState();
}

class WeatherDBMSState extends State<WeatherDBMS> {
  //StreamController<String> streamController = new StreamController();
  //Position position;
  //Position _currentPosition;

  static String weather = "Weather";
  static String dengue = "Dengue";
  static bool dengueEnabled = false;
  static bool weatherEnabled = false;
  Map<String, bool> days = {};

  bool getWeatherEnabled() {
    return weatherEnabled;
  }

  void setWeatherEnabled(bool value) {
    weatherEnabled = value;
  }

  @override
  void initState() {
    super.initState();
    print("ho");
    initPlatformState();
    print("hi");
  }

  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 15,
            stopOnTerminate: false,
            enableHeadless: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.NONE), (String taskId) async {
      // This is the fetch-event callback.
      print("[BackgroundFetch] Event received $taskId");
      // IMPORTANT:  You must signal completion of your task or the OS can punish your app
      // for taking too long in the background.
      String time;
      while (WeatherDBMSState.weatherEnabled == true) {
        time = await getWeather();
        if (time != null) {
          //Send this push notification when its done
          print("Gonna rain at $time");
          sleep(const Duration(seconds: 6)); //EDIT THIS
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        //appBar: BaseAppBar(),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),
                Text("Alert Preferences".toUpperCase(),
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 25.0)),
                SizedBox(height: 40),
                Row(children: <Widget>[
                  Text(
                    "Dengue".toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  Checkbox(
                    value: dengueEnabled,
                    onChanged: (bool value) {
                      setState(() {
                        dengueEnabled = value;
                      });
                    },
                  ),
                ]),
                SizedBox(height: 40),
                Row(children: <Widget>[
                  Text(
                    "Weather".toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  Checkbox(
                    value: weatherEnabled,
                    onChanged: (bool value) {
                      setState(() {
                        weatherEnabled = value;
                        debugPrint(weatherEnabled.toString());
                      });
                      if (weatherEnabled) {
                        BackgroundFetch.start().then((int status) {
                          print('[BackgroundFetch] start success: $status');
                        }).catchError((e) {
                          print('[BackgroundFetch] start FAILURE: $e');
                        });
                      } else {
                        BackgroundFetch.stop().then((int status) {
                          print('[BackgroundFetch] stop success: $status');
                        });
                      }
                    },
                  ),
                ]),
                //LocalNotificationWidget(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
