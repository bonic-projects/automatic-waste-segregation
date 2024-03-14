//movement direction of the waste bin rotation
class DeviceMovement {
  String? direction;
  bool isAuto;
  DateTime? lastSeen;

  //

  DeviceMovement({
    required this.direction,
    required this.isAuto,
    this.lastSeen,
  });

//
  factory DeviceMovement.fromMap(Map data) {
    return DeviceMovement(
      direction: data['direction'],
      isAuto: data['isAuto'] ?? false,
      lastSeen: DateTime.fromMillisecondsSinceEpoch(data['ts']),
    );
  }

  //
  Map<String, dynamic> toJson() => {
        'direction': direction,
        'isAuto': isAuto,
        'ts':lastSeen,
      };
}
