class SensorConfig {
  String? sensorName;
  String? sensorType;
  int? registerNumber;
  double? min;
  double? max;
  double? multiplier;
  double? offset;

  SensorConfig({
    this.sensorName, this.sensorType, this.registerNumber, 
    this.min, this.max, this.multiplier, this.offset
  });

  Map<String, dynamic> toJson() => {
    'sensorName': sensorName,
    'sensorType': sensorType,
    'registerNumber': registerNumber,
    'min': min,
    'max': max,
    'multiplier': multiplier,
    'offset': offset,
  };

  factory SensorConfig.fromJson(Map<String, dynamic> json) => SensorConfig(
    sensorName: json['sensorName'],
    sensorType: json['sensorType'],
    registerNumber: json['registerNumber'],
    min: json['min']?.toDouble(),
    max: json['max']?.toDouble(),
    multiplier: json['multiplier']?.toDouble(),
    offset: json['offset']?.toDouble(),
  );
}

class Recipe {
  final String sr;
  final String model; // Constant
  final String type;  // Constant
  final String recipeId;
  final List<SensorConfig> sensors; // Many sensor configs here

  Recipe({
    required this.sr,
    required this.model,
    required this.type,
    required this.recipeId,
    required this.sensors,
  });

  Map<String, dynamic> toJson() => {
    'sr': sr,
    'model': model,
    'type': type,
    'recipeId': recipeId,
    'sensors': sensors.map((s) => s.toJson()).toList(),
  };

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      sr: json['sr'] ?? "",
      model: json['model'] ?? "",
      type: json['type'] ?? "",
      recipeId: json['recipeId'] ?? "",
      sensors: (json['sensors'] as List?)
              ?.map((s) => SensorConfig.fromJson(s))
              .toList() ?? [],
    );
  }
}