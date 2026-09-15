class LiveTelemetryResponse {
  final double temperature;
  final double humidity;
  final double nh3;
  final double lpg;
  final String timestamp;

  LiveTelemetryResponse({
    required this.temperature,
    required this.humidity,
    required this.nh3,
    required this.lpg,
    required this.timestamp,
  });

  factory LiveTelemetryResponse.fromJson(Map<String, dynamic> json) {
    return LiveTelemetryResponse(
      temperature: (json['temperature'] as num? ?? 0.0).toDouble(),
      humidity: (json['humidity'] as num? ?? 0.0).toDouble(),
      nh3: (json['nh3'] as num? ?? 0.0).toDouble(),
      lpg: (json['lpg'] as num? ?? 0.0).toDouble(),
      timestamp: json['timestamp'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'humidity': humidity,
      'nh3': nh3,
      'lpg': lpg,
      'timestamp': timestamp,
    };
  }
}

class TelemetryResponse {
  final String timestamp;
  final double? temperature;
  final double? humidity;
  final double? nh3;
  final double? lpg;

  TelemetryResponse({
    required this.timestamp,
    this.temperature,
    this.humidity,
    this.nh3,
    this.lpg,
  });

  // ADD THIS METHOD SO WE CAN MODIFY TIMESTAMPS EASILY
  TelemetryResponse copyWith({
    String? timestamp,
    double? temperature,
    double? humidity,
    double? nh3,
    double? lpg,
  }) {
    return TelemetryResponse(
      timestamp: timestamp ?? this.timestamp,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      nh3: nh3 ?? this.nh3,
      lpg: lpg ?? this.lpg,
    );
  }

  factory TelemetryResponse.fromJson(Map<String, dynamic> json) {
    return TelemetryResponse(
      timestamp: json['timestamp'] as String? ?? '',
      temperature: json['temperature'] != null ? (json['temperature'] as num).toDouble() : null,
      humidity: json['humidity'] != null ? (json['humidity'] as num).toDouble() : null,
      nh3: json['nh3'] != null ? (json['nh3'] as num).toDouble() : null,
      lpg: json['lpg'] != null ? (json['lpg'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      if (temperature != null) 'temperature': temperature,
      if (humidity != null) 'humidity': humidity,
      if (nh3 != null) 'nh3': nh3,
      if (lpg != null) 'lpg': lpg,
    };
  }
}
