import 'package:geolocator/geolocator.dart';

/// a service class to get the current location of the user.
class CurrentLocation {
  double latitude;
  double longitude;

  Future getCurrentLocation() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;
      return {'latitude': latitude, 'longitude': longitude};
    } catch (e) {
      print(e);
      return null;
    }
  }
}