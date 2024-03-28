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
        'ts': lastSeen,
      };
}

/// Device Sensor Reading model
class DeviceReading {
  int dry;

  int metal;
  int wet;
  DateTime lastSeen;

  DeviceReading({
    required this.dry,
    required this.wet,
    required this.metal,
    required this.lastSeen,
  });

  factory DeviceReading.fromMap(Map data) {
    return DeviceReading(
      lastSeen: DateTime.fromMillisecondsSinceEpoch(data['ts']),
      dry: data['dry'] ?? 'nill',
      wet: data['wet'] ?? 'nill',
      metal: data['metal'] ?? 'nill',
    );
  }
}
