//movement direction of the waste bin rotation
class DeviceMovement {
  String? direction;
  bool isAuto;

  //

  DeviceMovement({
    required this.direction,
    required this.isAuto,
  });

//
  factory DeviceMovement.fromMap(Map data) {
    return DeviceMovement(
      direction: data['direction'] , isAuto: data['isAuto'] ?? false,
    );
  }

  //
  Map<String, dynamic> toJson() => {
        'direction': direction,
        'isAuto': isAuto,
      };
}
