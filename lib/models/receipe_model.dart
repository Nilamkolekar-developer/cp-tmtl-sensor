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

  SensorConfig(
      {this.sensorName,
      this.sensorType,
      this.registerNumber,
      this.min,
      this.max,
      this.multiplier,
      this.offset,
      this.unit,
      this.testResult});

  Map<String, dynamic> toJson() => {
        'sensorName': sensorName,
        'sensorType': sensorType,
        'registerNumber': registerNumber,
        'min': min,
        'max': max,
        'multiplier': multiplier,
        'offset': offset,
        'unit': unit,
        'testResult': testResult
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
      );
}

class Recipe {
  String? sr;
  String? model; // Constant
  String? type; // Constant

  List<SensorConfig>? sensors; // Many sensor configs here

  Recipe({
    this.sr,
    this.model,
    this.type,
    this.sensors,
  });

  Map<String, dynamic> toJson() => {
        'sr': sr,
        'model': model,
        'type': type,
        'sensors': sensors!.map((s) => s.toJson()).toList(),
      };

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      sr: json['sr'] ?? "",
      model: json['model'] ?? "",
      type: json['type'] ?? "",
      sensors: (json['sensors'] as List?)
              ?.map((s) => SensorConfig.fromJson(s))
              .toList() ??
          [],
    );
  }
}
