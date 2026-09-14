import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:clucknet_app/core/network/api_service.dart';
import 'package:clucknet_app/features/zones/presentation/providers/zones_provider.dart';
import 'package:clucknet_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:clucknet_app/features/shared/data/models/zone_models.dart';
import 'package:clucknet_app/features/shared/data/models/device_models.dart';
import 'package:clucknet_app/core/theme/app_theme.dart';
import 'package:clucknet_app/features/zones/presentation/widgets/sensor_gauge.dart';
import 'package:clucknet_app/features/zones/presentation/utils/climate_status.dart';
import 'package:clucknet_app/features/profile/presentation/providers/farmers_provider.dart';
import 'package:clucknet_app/features/alerts/presentation/providers/alerts_provider.dart';
import 'package:clucknet_app/features/shared/data/models/alert_models.dart';

class ZoneDetailScreen extends ConsumerStatefulWidget {
  final int zoneId;

  const ZoneDetailScreen({super.key, required this.zoneId});

  @override
  ConsumerState<ZoneDetailScreen> createState() => _ZoneDetailScreenState();
}

class _ZoneDetailScreenState extends ConsumerState<ZoneDetailScreen> {
  String _range = '24h'; // '24h' or '7d'

  @override
  Widget build(BuildContext context) {
    final zoneAsync = ref.watch(zoneDetailProvider(widget.zoneId));
    final telemetryAsync = ref.watch(liveTelemetryProvider(widget.zoneId));
    final historyAsync = ref.watch(telemetryHistoryProvider(TelemetryHistoryParam(widget.zoneId, _range)));
    final alertsAsync = ref.watch(alertsProvider(widget.zoneId));
    final authState = ref.watch(authProvider);
    final farmers = ref.watch(farmersProvider);
    final assignedFarmer = farmers.where((f) => f.assignedZones.contains(widget.zoneId)).firstOrNull;

    // Sync alerts with live telemetry polling to ensure "immediate" updates
    ref.listen(liveTelemetryProvider(widget.zoneId), (prev, next) {
      if (next.hasValue) {
        ref.invalidate(alertsProvider(widget.zoneId));
      }
    });

    final isOwner = authState.role == 'OWNER';
    final isFarmer = authState.role == 'FARMER';
    final showSettings = isOwner || isFarmer;

    return Scaffold(
      appBar: AppBar(
        title: zoneAsync.when(
          data: (zone) => Text(zone.name),
          loading: () => const Text('Loading Zone...'),
          error: (_, __) => const Text('Zone Details'),
        ),
        actions: [
          if (showSettings)
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => context.push('/thresholds/${widget.zoneId}'),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(zoneDetailProvider(widget.zoneId));
          ref.invalidate(liveTelemetryProvider(widget.zoneId));
          ref.invalidate(telemetryHistoryProvider(TelemetryHistoryParam(widget.zoneId, _range)));
          ref.invalidate(alertsProvider(widget.zoneId));
        },
        child: zoneAsync.when(
          data: (zone) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Live Telemetry stream display
                  telemetryAsync.when(
                    data: (telemetry) {
                      double? displayedLpg = telemetry.lpg;
                      DateTime displayedTimestamp = DateTime.tryParse(telemetry.timestamp) ?? DateTime.now();

                      // Get the latest active or resolved LPG alert to compare timestamps
                      final activeLpgAlert = alertsAsync.maybeWhen(
                        data: (alerts) => alerts.where(
                          (a) => a.type == 'LPG_DANGER'
                        ).firstOrNull,
                        orElse: () => null,
                      );

                      if (activeLpgAlert != null) {
                        final alertTime = DateTime.tryParse(activeLpgAlert.createdAt);
                        if (alertTime != null && alertTime.isAfter(displayedTimestamp)) {
                          final parsedLpg = activeLpgAlert.triggeredValue;
                          if (parsedLpg != null) {
                            displayedLpg = parsedLpg;
                            displayedTimestamp = alertTime;
                          }
                        }
                      }

                      final overallStatus = ClimateStatusHelper.getOverallStatus(
                        temp: telemetry.temperature,
                        hum: telemetry.humidity,
                        nh3: telemetry.nh3,
                        lpg: displayedLpg,
                        threshold: zone.threshold,
                      );

                      return Column(
                        children: [
                          // Danger Stripe Banner if status is not safe
                          if (overallStatus != SensorStatus.safe)
                            _buildStripeDangerBanner(context, overallStatus),

                          // Specialized LPG alert display
                          alertsAsync.maybeWhen(
                            data: (alerts) {
                              final activeLpgAlert = alerts.where(
                                (a) => a.status == 'ACTIVE' && a.type == 'LPG_DANGER'
                              ).firstOrNull;
                              
                              if (activeLpgAlert != null) {
                                return _buildLpgAlertCard(context, activeLpgAlert);
                              }
                              return const SizedBox.shrink();
                            },
                            orElse: () => const SizedBox.shrink(),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     const Text(
                                       'Live Readings',
                                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                     ),
                                     if (assignedFarmer != null)
                                       Text(
                                         'Assigned: ${assignedFarmer.username}',
                                         style: TextStyle(
                                           fontSize: 13,
                                           color: Colors.grey.shade600,
                                           fontWeight: FontWeight.w500,
                                         ),
                                       ),
                                   ],
                                 ),
                                const SizedBox(height: 12),
                                // Gauges 2x2 Grid
                                AspectRatio(
                                  aspectRatio: 1.0,
                                  child: GridView.count(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    physics: const NeverScrollableScrollPhysics(),
                                    children: [
                                      SensorGauge(
                                        value: telemetry.temperature,
                                        minVal: 0,
                                        maxVal: 50,
                                        label: 'Temperature',
                                        unit: '°C',
                                        color: _getSensorColor(
                                          context,
                                          ClimateStatusHelper.getTemperatureStatus(
                                              telemetry.temperature, zone.threshold),
                                        ),
                                      ),
                                      SensorGauge(
                                        value: telemetry.humidity,
                                        minVal: 0,
                                        maxVal: 100,
                                        label: 'Humidity',
                                        unit: '%',
                                        color: _getSensorColor(
                                          context,
                                          ClimateStatusHelper.getHumidityStatus(
                                              telemetry.humidity, zone.threshold),
                                        ),
                                      ),
                                      SensorGauge(
                                        value: telemetry.nh3,
                                        minVal: 0,
                                        maxVal: 50,
                                        label: 'Ammonia (NH₃)',
                                        unit: 'ppm',
                                        color: _getSensorColor(
                                          context,
                                          ClimateStatusHelper.getNh3Status(
                                              telemetry.nh3, zone.threshold),
                                        ),
                                      ),
                                      SensorGauge(
                                        value: displayedLpg,
                                        minVal: 0,
                                        maxVal: 100,
                                        label: 'LPG Gas',
                                        unit: 'ppm',
                                        color: _getSensorColor(
                                          context,
                                          ClimateStatusHelper.getLpgStatus(
                                              displayedLpg, zone.threshold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Center(
                                  child: Text(
                                    'Last updated: ${DateFormat('hh:mm:ss a').format(displayedTimestamp.toLocal())}',
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 48.0),
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 12),
                            Text('Loading live sensor stream...'),
                          ],
                        ),
                      ),
                    ),
                    error: (error, _) => Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Text(
                          'Telemetry Connection Lost: $error',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ),

                  // Threshold Overview Card
                  _buildThresholdOverviewCard(context, zone.threshold),

                  // Device Assignment Card
                  _buildDeviceAssignmentCard(context, isOwner),

                  // Historical Charts Section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Historical Trends',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SegmentedButton<String>(
                              segments: const [
                                ButtonSegment<String>(
                                  value: '24h',
                                  label: Text('24 Hours'),
                                ),
                                ButtonSegment<String>(
                                  value: '7d',
                                  label: Text('7 Days'),
                                ),
                              ],
                              selected: {_range},
                              onSelectionChanged: (value) {
                                setState(() {
                                  _range = value.first;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        historyAsync.when(
                          data: (history) {
                            if (history.isEmpty) {
                              return const Card(
                                child: Padding(
                                  padding: EdgeInsets.all(32.0),
                                  child: Center(
                                    child: Text(
                                      'No historical telemetry data found for this range.',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return Column(
                              children: [
                                _buildHistoricalCard(
                                  context,
                                  title: 'Temperature (°C)',
                                  color: Colors.red.shade600,
                                  unit: '°C',
                                  data: history
                                      .where((h) => h.temperature != null)
                                      .map((h) => FlSpot(
                                            DateTime.parse(h.timestamp).millisecondsSinceEpoch.toDouble(),
                                            h.temperature!,
                                          ))
                                      .toList(),
                                ),
                                _buildHistoricalCard(
                                  context,
                                  title: 'Humidity (%)',
                                  color: Colors.blue.shade600,
                                  unit: '%',
                                  data: history
                                      .where((h) => h.humidity != null)
                                      .map((h) => FlSpot(
                                            DateTime.parse(h.timestamp).millisecondsSinceEpoch.toDouble(),
                                            h.humidity!,
                                          ))
                                      .toList(),
                                ),
                                _buildHistoricalCard(
                                  context,
                                  title: 'Ammonia (NH₃ ppm)',
                                  color: Colors.amber.shade700,
                                  unit: ' ppm',
                                  data: history
                                      .where((h) => h.nh3 != null)
                                      .map((h) => FlSpot(
                                            DateTime.parse(h.timestamp).millisecondsSinceEpoch.toDouble(),
                                            h.nh3!,
                                          ))
                                      .toList(),
                                ),
                                _buildHistoricalCard(
                                  context,
                                  title: 'LPG Gas (ppm)',
                                  color: Colors.purple.shade600,
                                  unit: ' ppm',
                                  data: history
                                      .where((h) => h.lpg != null)
                                      .map((h) => FlSpot(
                                            DateTime.parse(h.timestamp).millisecondsSinceEpoch.toDouble(),
                                            h.lpg!,
                                          ))
                                      .toList(),
                                ),
                              ],
                            );
                          },
                          loading: () => const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 40.0),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          error: (error, _) => Text(
                            'Failed to load charts: $error',
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Text('Failed to load zone detail: $error'),
          ),
        ),
      ),
    );
  }

  Color _getSensorColor(BuildContext context, SensorStatus status) {
    final sensorColors = Theme.of(context).extension<SensorColors>();
    switch (status) {
      case SensorStatus.safe:
        return sensorColors?.safe ?? Colors.green;
      case SensorStatus.warning:
        return sensorColors?.warning ?? Colors.orange;
      case SensorStatus.critical:
        return sensorColors?.critical ?? Colors.red;
    }
  }

  Widget _buildLpgAlertCard(BuildContext context, AlertResponse alert) {
    final valueStr = alert.triggeredValue?.toStringAsFixed(1) ?? '--';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.red.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.red.shade300, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.warning_rounded, color: Colors.red.shade800, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'LPG GAS DETECTED!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    alert.message,
                    style: TextStyle(fontSize: 12, color: Colors.red.shade900),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                Text(
                  valueStr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.red,
                  ),
                ),
                const Text(
                  'ppm',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStripeDangerBanner(BuildContext context, SensorStatus status) {
    final isCritical = status == SensorStatus.critical;
    final bannerColor = isCritical ? Colors.red.shade700 : Colors.orange.shade700;
    final message = isCritical
        ? 'DANGER: SENSOR VALUE BEYOND SAFE LIMITS!'
        : 'WARNING: CLIMATE DEVIATING FROM THRESHOLDS';

    return Container(
      color: bannerColor,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(isCritical ? Icons.error : Icons.warning_amber, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThresholdOverviewCard(BuildContext context, ThresholdResponse? t) {
    if (t == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.tune_outlined, size: 20, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    'Safe Climate Targets',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildThresholdRow('Temperature range', '${t.activeMinTemperature ?? t.minTemperature}°C - ${t.activeMaxTemperature ?? t.maxTemperature}°C'),
              const Divider(height: 12),
              _buildThresholdRow('Humidity range', '${t.activeMinHumidity ?? t.minHumidity}% - ${t.activeMaxHumidity ?? t.maxHumidity}%'),
              const Divider(height: 12),
              _buildThresholdRow('Ammonia (NH₃) limit', 'Under ${t.maxNh3} ppm'),
              const Divider(height: 12),
              _buildThresholdRow('LPG limit', 'Under ${t.maxLpg} ppm'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThresholdRow(String label, String rangeValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
        Text(rangeValue, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildHistoricalCard(
    BuildContext context, {
    required String title,
    required Color color,
    required String unit,
    required List<FlSpot> data,
  }) {
    if (data.isEmpty) {
      return const SizedBox.shrink();
    }

    // Find bounding box for Y values
    double minY = data.map((spot) => spot.y).reduce(math.min);
    double maxY = data.map((spot) => spot.y).reduce(math.max);
    
    // Add small buffer
    final buffer = (maxY - minY) * 0.15;
    minY = (minY - buffer).clamp(0.0, double.infinity);
    maxY = maxY + buffer;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 20),
            SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(
                    show: true,
                    drawVerticalLine: false,
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        interval: _range == '24h'
                            ? 60 * 60 * 1000 * 6 // 6 Hours
                            : 60 * 60 * 1000 * 24 * 2, // 2 Days
                        getTitlesWidget: (value, meta) {
                          final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                          if (_range == '24h') {
                            return Text(DateFormat('HH:mm').format(date), style: const TextStyle(fontSize: 10, color: Colors.grey));
                          } else {
                            return Text(DateFormat('E dd').format(date), style: const TextStyle(fontSize: 10, color: Colors.grey));
                          }
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 10, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minY: minY,
                  maxY: maxY,
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) => color.withOpacity(0.8),
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final timeStr = DateFormat('hh:mm a').format(
                            DateTime.fromMillisecondsSinceEpoch(spot.x.toInt()),
                          );
                          return LineTooltipItem(
                            '$timeStr\n${spot.y.toStringAsFixed(1)}$unit',
                            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data,
                      isCurved: true,
                      color: color,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: color.withOpacity(0.12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceAssignmentCard(BuildContext context, bool isOwner) {
    final deviceAsync = ref.watch(zoneDevicesProvider(widget.zoneId));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.developer_board_outlined, size: 20, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        'Device Assignment',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  if (isOwner)
                    IconButton(
                      icon: const Icon(Icons.refresh, size: 20, color: Colors.grey),
                      onPressed: () {
                        ref.invalidate(zoneDevicesProvider(widget.zoneId));
                      },
                    ),
                ],
              ),
              const SizedBox(height: 12),
              deviceAsync.when(
                data: (devices) {
                  if (devices.isEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'No device assigned to this zone.',
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                        ),
                      ],
                    );
                  }

                  final device = devices.first;
                  final isOnline = device.status.toUpperCase() == 'ONLINE';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                device.name,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'MAC: ${device.id}',
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isOnline ? Colors.green.shade50 : Colors.red.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isOnline ? Colors.green.shade300 : Colors.red.shade300,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: isOnline ? Colors.green : Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  device.status,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: isOnline ? Colors.green.shade800 : Colors.red.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (isOwner) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _showReassignDeviceDialog(context, device),
                                icon: const Icon(Icons.swap_horiz, size: 18),
                                label: const Text('Reassign'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _showRemoveDeviceDialog(context, device),
                                icon: const Icon(Icons.delete_outline, size: 18),
                                label: const Text('Remove'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (err, _) => Text(
                  'Failed to load device information: $err',
                  style: const TextStyle(color: Colors.red, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReassignDeviceDialog(BuildContext context, DeviceResponse device) {
    if (ref.read(authProvider).role != 'OWNER') return;

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          title: const Text('Reassign Device'),
          content: Consumer(
            builder: (context, ref, _) {
              final zonesAsync = ref.watch(zonesProvider);

              return zonesAsync.when(
                data: (zones) {
                  final otherZones = zones.where((z) => z.id != widget.zoneId).toList();
                  if (otherZones.isEmpty) {
                    return const Text('No other zones available to reassign this device to.');
                  }

                  return SizedBox(
                    width: double.maxFinite,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: otherZones.length,
                      itemBuilder: (context, index) {
                        final zone = otherZones[index];
                        return ListTile(
                          title: Text(zone.name),
                          subtitle: Text(zone.deviceName != null ? 'Current: ${zone.deviceName}' : 'No device'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () async {
                            Navigator.pop(dialogCtx);
                            _showLoadingOverlay(context);

                            try {
                              await ref.read(apiServiceProvider).reassignDevice(device.id, zone.id);
                              
                              ref.invalidate(zoneDevicesProvider(widget.zoneId));
                              ref.invalidate(zoneDevicesProvider(zone.id));
                              ref.invalidate(zoneDetailProvider(widget.zoneId));
                              ref.invalidate(zonesProvider);

                              if (context.mounted) {
                                Navigator.pop(context); // Pop loading overlay
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Device reassigned to ${zone.name} successfully.')),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                Navigator.pop(context); // Pop loading overlay
                                _showErrorDialog(context, 'Reassignment Failed', e.toString());
                              }
                            }
                          },
                        );
                      },
                    ),
                  );
                },
                loading: () => const SizedBox(
                  height: 100,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, _) => Text('Error loading zones: $err', style: const TextStyle(color: Colors.red)),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showRemoveDeviceDialog(BuildContext context, DeviceResponse device) {
    if (ref.read(authProvider).role != 'OWNER') return;

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          title: const Text('Remove Device Assignment'),
          content: Text('Are you sure you want to remove ${device.name} (${device.id}) from this zone?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogCtx);
                _showLoadingOverlay(context);

                try {
                  await ref.read(apiServiceProvider).removeDeviceAssignment(widget.zoneId, device.id);
                  
                  ref.invalidate(zoneDevicesProvider(widget.zoneId));
                  ref.invalidate(unassignedDevicesProvider);
                  ref.invalidate(zoneDetailProvider(widget.zoneId));
                  ref.invalidate(zonesProvider);

                  if (context.mounted) {
                    Navigator.pop(context); // Pop loading
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Device assignment removed successfully.')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context); // Pop loading
                    _showErrorDialog(context, 'Removal Failed', e.toString());
                  }
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  void _showLoadingOverlay(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
