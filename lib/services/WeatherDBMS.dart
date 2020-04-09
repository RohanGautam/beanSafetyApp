import 'dart:async';
import 'dart:io';
import 'package:background_fetch/background_fetch.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

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
    // IMPORTANT:  You must signal completion of your task or the OS can punish your app
    // for taking too long in the background.
    String time;
    while (weatherEnabled == true) {
      time = await getWeather();
      if(time != null){
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