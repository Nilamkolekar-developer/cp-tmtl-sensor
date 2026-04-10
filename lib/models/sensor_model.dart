class SensorModel {
  String name;
  String type;
  String register;
  String min;
  String max;
  String multiplier;
  String offset;

  SensorModel({
    required this.name,
    required this.type,
    required this.register,
    required this.min,
    required this.max,
    required this.multiplier,
    required this.offset,
  });

  // Convert JSON Map to SensorModel object
  factory SensorModel.fromJson(Map<String, dynamic> json) {
    return SensorModel(
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      register: json['register'] ?? '',
      min: json['min']?.toString() ?? '0',
      max: json['max']?.toString() ?? '0',
      multiplier: json['multiplier']?.toString() ?? '1.0',
      offset: json['offset']?.toString() ?? '0',
    );
  }

  // Convert SensorModel object to JSON Map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'register': register,
      'min': min,
      'max': max,
      'multiplier': multiplier,
      'offset': offset,
    };
  }
}