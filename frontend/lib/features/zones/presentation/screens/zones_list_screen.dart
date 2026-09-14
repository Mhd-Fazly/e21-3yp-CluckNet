import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:clucknet_app/features/zones/presentation/providers/zones_provider.dart';
import 'package:clucknet_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:clucknet_app/core/network/api_service.dart';
import 'package:clucknet_app/features/shared/data/models/zone_models.dart';
import 'package:clucknet_app/core/theme/app_theme.dart';
import 'package:clucknet_app/features/zones/presentation/utils/climate_status.dart';

class ZonesListScreen extends ConsumerWidget {
  const ZonesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zonesAsync = ref.watch(zonesProvider);
    final authState = ref.watch(authProvider);
    final isOwner = authState.role == 'OWNER';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Climate Zones'),
        actions: [
          if (isOwner)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showCreateZoneDialog(context, ref),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(zonesProvider);
        },
        child: zonesAsync.when(
          data: (zones) {
            if (zones.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.home_work_outlined, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No zones found',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Create a new zone using the "+" button in the app bar.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: zones.length,
              itemBuilder: (context, index) {
                final zone = zones[index];
                return _ZoneCard(zone: zone, isOwner: isOwner);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
                  const SizedBox(height: 16),
                  Text('Failed to load zones: $error', textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(zonesProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showCreateZoneDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Climate Zone'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Zone Name',
              hintText: 'e.g., Zone A - Broilers',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = controller.text.trim();
                if (name.isNotEmpty) {
                  Navigator.pop(context);
                  try {
                    await ref.read(apiServiceProvider).createZone(name);
                    ref.invalidate(zonesProvider);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Zone created successfully.')),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                      );
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size(80, 40)),
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
}

class _ZoneCard extends ConsumerWidget {
  final ZoneResponse zone;
  final bool isOwner;

  const _ZoneCard({required this.zone, required this.isOwner});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final telemetryAsync = ref.watch(liveTelemetryProvider(zone.id));

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => context.go('/zones/${zone.id}'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Zone Title & Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          zone.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          zone.deviceName != null
                              ? 'Device: ${zone.deviceName} (${zone.deviceStatus})'
                              : 'No Device Attached',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      // Overall status badge (watches live readings)
                      telemetryAsync.when(
                        data: (data) {
                          final status = ClimateStatusHelper.getOverallStatus(
                            temp: data.temperature,
                            hum: data.humidity,
                            nh3: data.nh3,
                            lpg: data.lpg,
                            threshold: zone.threshold,
                          );
                          return _buildStatusBadge(context, status);
                        },
                        loading: () => const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        error: (_, __) => _buildStatusBadge(context, SensorStatus.safe),
                      ),
                      const SizedBox(width: 8),
                      if (isOwner)
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => _confirmDeleteZone(context, ref),
                        ),
                      const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    ],
                  ),
                ],
              ),
              const Divider(height: 24),

              // Live telemetry readings
              telemetryAsync.when(
                data: (data) => GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 8,
                  children: [
                    _buildSensorCell(
                      context,
                      label: 'Temp',
                      value: '${data.temperature.toStringAsFixed(1)}°C',
                      status: ClimateStatusHelper.getTemperatureStatus(data.temperature, zone.threshold),
                    ),
                    _buildSensorCell(
                      context,
                      label: 'Humidity',
                      value: '${data.humidity.toStringAsFixed(0)}%',
                      status: ClimateStatusHelper.getHumidityStatus(data.humidity, zone.threshold),
                    ),
                    _buildSensorCell(
                      context,
                      label: 'NH₃',
                      value: '${data.nh3.toStringAsFixed(1)} ppm',
                      status: ClimateStatusHelper.getNh3Status(data.nh3, zone.threshold),
                    ),
                    _buildSensorCell(
                      context,
                      label: 'LPG',
                      value: '${data.lpg.toStringAsFixed(1)} ppm',
                      status: ClimateStatusHelper.getLpgStatus(data.lpg, zone.threshold),
                    ),
                  ],
                ),
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text('Connecting to sensor stream...', style: TextStyle(fontSize: 13, color: Colors.grey)),
                  ),
                ),
                error: (err, _) => Center(
                  child: Text('Live data error: $err', style: const TextStyle(fontSize: 12, color: Colors.red)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, SensorStatus status) {
    Color color;
    String text;
    switch (status) {
      case SensorStatus.safe:
        color = Theme.of(context).extension<SensorColors>()?.safe ?? Colors.green;
        text = 'Safe';
        break;
      case SensorStatus.warning:
        color = Theme.of(context).extension<SensorColors>()?.warning ?? Colors.orange;
        text = 'Warning';
        break;
      case SensorStatus.critical:
        color = Theme.of(context).extension<SensorColors>()?.critical ?? Colors.red;
        text = 'Danger';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSensorCell(BuildContext context, {required String label, required String value, required SensorStatus status}) {
    Color color;
    switch (status) {
      case SensorStatus.safe:
        color = Theme.of(context).extension<SensorColors>()?.safe ?? Colors.green;
        break;
      case SensorStatus.warning:
        color = Theme.of(context).extension<SensorColors>()?.warning ?? Colors.orange;
        break;
      case SensorStatus.critical:
        color = Theme.of(context).extension<SensorColors>()?.critical ?? Colors.red;
        break;
    }

    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color),
          ),
        ),
      ],
    );
  }

  void _confirmDeleteZone(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Zone'),
          content: Text('Are you sure you want to delete "${zone.name}"? This will detach all associated devices.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await ref.read(apiServiceProvider).deleteZone(zone.id);
                  ref.invalidate(zonesProvider);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Zone deleted successfully.')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error deleting zone: $e'), backgroundColor: Colors.red),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, minimumSize: const Size(80, 40)),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
