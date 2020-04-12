import 'package:flutter/foundation.dart';
import 'package:firebase_tutorial/Control/services/WeatherDBMS.dart' as weather;
import 'package:firebase_tutorial/Control/services/DengueDBMS.dart' as dengue;
import 'package:firebase_tutorial/NotifictionType.dart';
import 'package:firebase_tutorial/Control/services/LocalNotifications.dart'
    as local;

class Notification {
  int id;
  String title;
  String body;

  static Notification create(NotificationType type) {}
  void registerUser() {}
  void unregisterUser() {}
  void notifyUser() {
    local.showNotification(id, title, body);
  }
}

class DengueNotification extends Notification {
  void registerUser() {
    dengue.register();
  }

  void unregisterUser() {
    dengue.register();
  }
}

class WeatherNotification extends Notification {
  void registerUser() {
    weather.register();
  }

  void unregisterUser() {
    weather.unregister();
  }
}

// Factory Pattern
Notification create(NotificationType type) {
  if (type == NotificationType.WEATHER) {
    return new DengueNotification();
  } else if (type == describeEnum(NotificationType.DENGUE)) {
    return new WeatherNotification();
  } else {
    return null;
  }
}
