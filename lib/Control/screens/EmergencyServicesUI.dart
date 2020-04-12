import 'package:firebase_tutorial/Control/services/EmergencyServiceMap.dart';
import 'package:firebase_tutorial/Widget/RoundIconButton.dart';
import 'package:firebase_tutorial/Widget/BaseAppBar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_tutorial/Entity/EmergencyService.dart';
import 'package:firebase_tutorial/Entity/EmergencyServiceDB.dart';

/// This is a UI class for emergency services. It contains the Page and the
/// selection buttons for the emergency service type.
/// It proceeds to call the service `emergencyServiceMap` to display the specified type of locations on a map.
class EmergencyServicesUI extends StatelessWidget {
  EmergencyServiceDB sdb;

  void addService() {
    sdb.setServiceList(EmergencyService(name: 'hospital', iconID: 58696));
    sdb.setServiceList(EmergencyService(name: 'pharmacy', iconID: 58704));
    sdb.setServiceList(EmergencyService(name: 'police', iconID: 59516));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppBar(title: 'EMERGENCY SERVICES'),
        body: Stack(
          children: <Widget>[
            Positioned(
                width: MediaQuery.of(context).size.width,
                top: MediaQuery.of(context).size.width *
                    0.02, //TRY TO CHANGE THIS *0.30* value to achieve your goal
                child: Container(
                  margin: EdgeInsets.all(16.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/maps-and-location.png',
                          scale: 4.0,
                        ),
                        SizedBox(height: 12.0),
                        Text(
                            'Check the location of the relevant emergency service',
                            style:
                                TextStyle(fontSize: 15.0, color: Colors.grey))
                      ]),
                )),
            Padding(
              padding: EdgeInsets.fromLTRB(10.0, 200.0, 10.0, 0.0),
              child: GridView.count(
                crossAxisCount: 1,
                childAspectRatio: 3,
                //padding: const EdgeInsets.all(10.0),
                //shrinkWrap: true,
                children: <Widget>[
                  RoundIconButton(
                    icon: IconData(sdb.getServiceList()[0].iconID,
                        fontFamily: 'MaterialIcons'),
                    mpr: MaterialPageRoute(
                        builder: (context) => MyMap(
                            type: sdb.getServiceList()[0].name.toLowerCase())),
                    text: sdb.getServiceList()[0].name.toUpperCase(),
                  ),
                  RoundIconButton(
                    icon: IconData(sdb.getServiceList()[1].iconID,
                        fontFamily: 'MaterialIcons'),
                    mpr: MaterialPageRoute(
                        builder: (context) => MyMap(
                            type: sdb.getServiceList()[1].name.toLowerCase())),
                    text: sdb.getServiceList()[1].name.toUpperCase(),
                  ),
                  RoundIconButton(
                    icon: IconData(sdb.getServiceList()[2].iconID,
                        fontFamily: 'MaterialIcons'),
                    mpr: MaterialPageRoute(
                        builder: (context) => MyMap(
                            type: sdb.getServiceList()[2].name.toLowerCase())),
                    text: sdb.getServiceList()[2].name.toUpperCase(),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
