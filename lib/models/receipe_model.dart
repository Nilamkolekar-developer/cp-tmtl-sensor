// class SensorConfig {
//   String? sensorName;
//   String? sensorType;
//   int? registerNumber;
//   double? min;
//   double? max;
//   double? multiplier;
//   double? offset;
//   String? unit;
//   String? testResult;

//   SensorConfig(
//       {this.sensorName,
//       this.sensorType,
//       this.registerNumber,
//       this.min,
//       this.max,
//       this.multiplier,
//       this.offset,
//       this.unit,
//       this.testResult});

//   Map<String, dynamic> toJson() => {
//         'sensorName': sensorName,
//         'sensorType': sensorType,
//         'registerNumber': registerNumber,
//         'min': min,
//         'max': max,
//         'multiplier': multiplier,
//         'offset': offset,
//         'unit': unit,
//         'testResult': testResult
//       };

//   factory SensorConfig.fromJson(Map<String, dynamic> json) => SensorConfig(
//         sensorName: json['sensorName'],
//         sensorType: json['sensorType'],
//         registerNumber: json['registerNumber'],
//         min: json['min']?.toDouble(),
//         max: json['max']?.toDouble(),
//         multiplier: json['multiplier']?.toDouble(),
//         offset: json['offset']?.toDouble(),
//         unit: json['unit'],
//         testResult: json['testResult'],
//       );
// }

class OperationLog {
  final String sensorName;
  final String operation;       // "READ" or "WRITE"
  final String registerAddress;
  final String value;
  final String timestamp;

  OperationLog({
    required this.sensorName,
    required this.operation,
    required this.registerAddress,
    required this.value,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'sensorName': sensorName,
        'operation': operation,
        'registerAddress': registerAddress,
        'value': value,
        'timestamp': timestamp,
      };

  factory OperationLog.fromJson(Map<String, dynamic> json) => OperationLog(
        sensorName: json['sensorName'] ?? '',
        operation: json['operation'] ?? '',
        registerAddress: json['registerAddress'] ?? '',
        value: json['value'] ?? '',
        timestamp: json['timestamp'] ?? '',
      );
}

// ─────────────────────────────────────────────────────────────────────────────

class SensorConfig {
  String? sensorName;
  String? sensorType;
  int? registerNumber;
  double? min;
  double? max;
  double? multiplier;
  double? offset;
  String? unit;
  String? testResult;
  List<OperationLog> operations;   // non-nullable, always a list

  SensorConfig({
    this.sensorName,
    this.sensorType,
    this.registerNumber,
    this.min,
    this.max,
    this.multiplier,
    this.offset,
    this.unit,
    this.testResult,
    List<OperationLog>? operations,
  }) : operations = operations ?? [];

  /// Adds a new log entry directly on this sensor
  void addLog({
    required String operation,
    required String registerAddress,
    required String value,
  }) {
    final now = DateTime.now();
    operations.add(OperationLog(
      sensorName: sensorName ?? '',
      operation: operation,
      registerAddress: registerAddress,
      value: value,
      timestamp:
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}",
    ));
  }

  Map<String, dynamic> toJson() => {
        'sensorName': sensorName,
        'sensorType': sensorType,
        'registerNumber': registerNumber,
        'min': min,
        'max': max,
        'multiplier': multiplier,
        'offset': offset,
        'unit': unit,
        'testResult': testResult,
        'operations': operations.map((o) => o.toJson()).toList(),
      };

  factory SensorConfig.fromJson(Map<String, dynamic> json) => SensorConfig(
        sensorName: json['sensorName'],
        sensorType: json['sensorType'],
        registerNumber: json['registerNumber'],
        min: json['min']?.toDouble(),
        max: json['max']?.toDouble(),
        multiplier: json['multiplier']?.toDouble(),
        offset: json['offset']?.toDouble(),
        unit: json['unit'],
        testResult: json['testResult'],
        operations: (json['operations'] as List?)
                ?.map((o) => OperationLog.fromJson(o))
                .toList() ??
            [],
      );
}

// ─────────────────────────────────────────────────────────────────────────────

class Recipe {
  String? sr;
  String? model;
  String? type;
  List<SensorConfig> sensors;    // non-nullable, always a list

  Recipe({
    this.sr,
    this.model,
    this.type,
    List<SensorConfig>? sensors,
  }) : sensors = sensors ?? [];

  Map<String, dynamic> toJson() => {
        'sr': sr,
        'model': model,
        'type': type,
        'sensors': sensors.map((s) => s.toJson()).toList(),
      };

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        sr: json['sr'] ?? '',
        model: json['model'] ?? '',
        type: json['type'] ?? '',
        sensors: (json['sensors'] as List?)
                ?.map((s) => SensorConfig.fromJson(s))
                .toList() ??
            [],
      );
}