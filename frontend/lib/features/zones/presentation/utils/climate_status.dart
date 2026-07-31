import '../../../shared/data/models/zone_models.dart';

enum SensorStatus { safe, warning, critical }

class ClimateStatusHelper {
  static SensorStatus getTemperatureStatus(double val, ThresholdResponse? t) {
    if (t == null) return SensorStatus.safe;
    final minT = t.activeMinTemperature ?? t.minTemperature;
    final maxT = t.activeMaxTemperature ?? t.maxTemperature;
    if (val < minT || val > maxT) return SensorStatus.critical;
    // Warning buffer of 2°C near boundaries
    if (val < minT + 2.0 || val > maxT - 2.0) return SensorStatus.warning;
    return SensorStatus.safe;
  }

  static SensorStatus getHumidityStatus(double val, ThresholdResponse? t) {
    if (t == null) return SensorStatus.safe;
    final minH = t.activeMinHumidity ?? t.minHumidity;
    final maxH = t.activeMaxHumidity ?? t.maxHumidity;
    if (val < minH || val > maxH) return SensorStatus.critical;
    // Warning buffer of 5% near boundaries
    if (val < minH + 5.0 || val > maxH - 5.0) return SensorStatus.warning;
    return SensorStatus.safe;
  }

  static SensorStatus getNh3Status(double val, ThresholdResponse? t) {
    if (t == null) return SensorStatus.safe;
    if (val > t.maxNh3) return SensorStatus.critical;
    // Warning buffer when within 80% of threshold
    if (val > t.maxNh3 * 0.8) return SensorStatus.warning;
    return SensorStatus.safe;
  }

  static SensorStatus getLpgStatus(double val, ThresholdResponse? t) {
    if (t == null) return SensorStatus.safe;
    if (val > t.maxLpg) return SensorStatus.critical;
    // Warning buffer when within 80% of threshold
    if (val > t.maxLpg * 0.8) return SensorStatus.warning;
    return SensorStatus.safe;
  }

  // Returns overall status based on all 4 sensors
  static SensorStatus getOverallStatus({
    required double temp,
    required double hum,
    required double nh3,
    required double lpg,
    required ThresholdResponse? threshold,
  }) {
    final s1 = getTemperatureStatus(temp, threshold);
    final s2 = getHumidityStatus(hum, threshold);
    final s3 = getNh3Status(nh3, threshold);
    final s4 = getLpgStatus(lpg, threshold);

    if (s1 == SensorStatus.critical ||
        s2 == SensorStatus.critical ||
        s3 == SensorStatus.critical ||
        s4 == SensorStatus.critical) {
      return SensorStatus.critical;
    }
    if (s1 == SensorStatus.warning ||
        s2 == SensorStatus.warning ||
        s3 == SensorStatus.warning ||
        s4 == SensorStatus.warning) {
      return SensorStatus.warning;
    }
    return SensorStatus.safe;
  }
}
