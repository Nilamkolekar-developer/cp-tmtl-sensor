class SensorFormulaService {
  static double calculate({
    required String sensorType,
    required double x,
    double r1 = 0,
    double vin = 0,
    double vout = 0,
    double m = 0,
    double c = 0,
  }) {
    switch (sensorType.toLowerCase()) {
      case "resistance":
      case "r2":
        return _calculateR2(r1, vin, vout);

      case "linear":
      case "y=mx+c":
        return _calculateLinear(m, x, c);

      default:
        return x; // fallback
    }
  }

  static double _calculateR2(double r1, double vin, double vout) {
    if (vin - vout == 0) return 0;
    return r1 * vout / (vin - vout);
  }

  static double _calculateLinear(double m, double x, double c) {
    return m * x + c;
  }
}