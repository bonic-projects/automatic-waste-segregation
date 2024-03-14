import 'package:aws_flutter/app/app.bottomsheets.dart';
import 'package:aws_flutter/app/app.locator.dart';
import 'package:aws_flutter/models/device_data.dart';
import 'package:aws_flutter/services/device_database_service.dart';
import 'package:aws_flutter/ui/common/app_strings.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends ReactiveViewModel {
  final _deviceDatabaseService = locator<DeviceDatabaseService>();
  final _bottomSheetService = locator<BottomSheetService>();
  // final _navigatonService = locator<NavigationService>();

  @override
  List<ListenableServiceMixin> get listenableServices =>
      [_deviceDatabaseService];

//init method it calls initially when the device is ready
  void onModelReady() {
    _deviceDatabaseService.setDeviceData(DeviceMovement(
      direction: null,
      isAuto: true,
    ));
  }

  //methods for control Waste Bins

  void isBinMovement(String value) {
    _deviceDatabaseService
        .setDeviceData(DeviceMovement(direction: value, isAuto: false));
  }

  // bool _buttonEnable = false;
  // bool get buttonEnable => _buttonEnable;

  bool _isAuto = true;
  bool get isAuto => _isAuto;

  void setDataIsAutomatic(bool value) {
    _deviceDatabaseService
        .setDeviceData(DeviceMovement(direction: null, isAuto: value));
  }

  void autoButton(bool value) {
    _isAuto = value;

    setDataIsAutomatic(_isAuto);
    notifyListeners();
  }

  void showBottomSheet() {
    _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.notice,
      title: ksHomeBottomSheetTitle,
      description: ksHomeBottomSheetDescription,
    );
  }
}
