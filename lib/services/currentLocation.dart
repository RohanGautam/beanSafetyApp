import 'package:firebase_tutorial/models/userData.dart';
import 'package:geolocator/geolocator.dart';

class CurrentLocation {
  double latitude;
  double longitude;

  Future getCurrentLocation() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;
      return UserData(latitude: latitude, longitude: longitude);
    } catch (e) {
      print(e);
      return null;
    }
  }
}