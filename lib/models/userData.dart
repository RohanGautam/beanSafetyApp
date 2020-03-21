class UserData {
  final String uid;
  // location info
  double latitude;
  double longitude;
  //peer notification info
  bool alerter;
  bool alerted;
  bool responder;

  UserData(
      {this.uid,
      this.latitude,
      this.longitude,
      this.alerter = false,
      this.alerted = false,
      this.responder = false});
}
