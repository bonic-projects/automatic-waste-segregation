import 'package:aws_flutter/app/app.logger.dart';
import 'package:aws_flutter/models/device_data.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:stacked/stacked.dart';

const dbCode = "bbVmnG41eZfKzvlIOPr9d7RJQ8w2";

class DeviceDatabaseService with ListenableServiceMixin {
  final log = getLogger('DatabaseService');
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  DeviceReading? _node;
  DeviceReading? get node => _node;

  void setupNodeListening() async{
    DatabaseReference starCountRef = _db.ref('/devices/$dbCode/reading');
       log.i("R ${starCountRef.key}");
    try  {
     starCountRef.onValue.listen((DatabaseEvent event) {
          log.i("Reading..");
        if (event.snapshot.exists) {
          _node = DeviceReading.fromMap(event.snapshot.value as Map);
              log.v(_node?.dry ?? "dry"); //data['time']
          notifyListeners();
        }
      });
    } catch (e) {
        log.e("Error: $e");
    }
  }

  void setDeviceData(DeviceMovement data) {
    DatabaseReference dataRef = _db.ref('/devices/$dbCode/data');

    dataRef.update(data.toJson());

    //dataRef.update(data.toJson());
    //print(data.direction);
  }
}
