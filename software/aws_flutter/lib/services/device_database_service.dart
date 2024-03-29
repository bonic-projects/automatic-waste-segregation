import 'dart:developer';

import 'package:aws_flutter/models/device_data.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:stacked/stacked.dart';

const dbCode = "bbVmnG41eZfKzvlIOPr9d7RJQ8w2";

class DeviceDatabaseService with ListenableServiceMixin {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  DeviceMovement? _node;
  DeviceMovement? get node => _node;

  void setUpNodeListening() {
    DatabaseReference startCountRef = _db.ref('/devices/$dbCode/signal');

    try {
      startCountRef.onValue.listen((DatabaseEvent event) {
        if (event.snapshot.exists) {
          _node = DeviceMovement.fromMap(event.snapshot.value as Map);
          notifyListeners();
        }
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void setDeviceData(DeviceMovement data) {
    DatabaseReference dataRef = _db.ref('/devices/$dbCode/signal');

    dataRef.update(data.toJson());

    //dataRef.update(data.toJson());
    //print(data.direction);
  }
}
