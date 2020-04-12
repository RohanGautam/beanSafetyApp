import 'package:firebase_tutorial/Entity/EmergencyService.dart';

/// This class stores the list of Service objects
class EmergencyServiceDB {
  List<EmergencyService> emergencyServicesList = [];

  EmergencyServiceDB({this.emergencyServicesList});

  void setServiceList(EmergencyService service) {
    emergencyServicesList.add(service);
  }

  List<EmergencyService> getServiceList() {
    return emergencyServicesList;
  }
}
