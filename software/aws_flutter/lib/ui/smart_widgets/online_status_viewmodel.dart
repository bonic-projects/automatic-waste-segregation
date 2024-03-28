import 'dart:async';

import 'package:aws_flutter/models/device_data.dart';
import 'package:aws_flutter/services/device_database_service.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';



class HomeViewModel extends BaseViewModel {
  //final log = getLogger('StatusWidget');

  final _dbService = locator<DeviceDatabaseService>();

  DeviceReading? get node => _dbService.node;

  bool _isOnline = false;

  bool get isOnline => _isOnline;

  bool isOnlineCheck(DateTime? time) {
    if (time == null) return false;
    final DateTime now = DateTime.now();
    final difference = now.difference(time).inSeconds;
    // log.i("Status $difference");
    return difference.abs() <= 5;
  }

  late Timer timer;

  void setTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        _isOnline = isOnlineCheck(node?.lastSeen);
        notifyListeners();
      },
    );
  }
}
