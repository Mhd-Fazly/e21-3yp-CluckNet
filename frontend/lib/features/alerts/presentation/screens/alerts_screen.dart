import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/alerts_provider.dart';
import 'package:clucknet_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:clucknet_app/core/theme/app_theme.dart';

class AlertsScreen extends ConsumerStatefulWidget {
  const AlertsScreen({super.key});

  @override
  ConsumerState<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends ConsumerState<AlertsScreen> {
  String _severityFilter = 'ALL'; // 'ALL', 'CRITICAL', 'WARNING', 'INFO'
  String _statusFilter = 'ALL'; // 'ALL', 'ACTIVE', 'RESOLVED'

  @override
  Widget build(BuildContext context) {
    final alertsAsync = ref.watch(alertsProvider(null));
    final authState = ref.watch(authProvider);
    final isOwner = authState.role == 'OWNER';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Climate Alerts'),
      ),
      body: Column(
        children: [
          // Filter Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Theme.of(context).cardColor,
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _severityFilter,
                    decoration: const InputDecoration(
                      labelText: 'Severity',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'ALL', child: Text('All Severities')),
                      DropdownMenuItem(value: 'CRITICAL', child: Text('Critical')),
                      DropdownMenuItem(value: 'WARNING', child: Text('Warning')),
                      DropdownMenuItem(value: 'INFO', child: Text('Info')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _severityFilter = val;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _statusFilter,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'ALL', child: Text('All Statuses')),
                      DropdownMenuItem(value: 'ACTIVE', child: Text('Active')),
                      DropdownMenuItem(value: 'RESOLVED', child: Text('Resolved')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _statusFilter = val;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          // Alerts List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(alertsProvider(null));
              },
              child: alertsAsync.when(
                data: (alerts) {
                  // Apply client-side filters
                  var filteredAlerts = alerts;
                  if (_severityFilter != 'ALL') {
                    filteredAlerts = filteredAlerts
                        .where((a) => a.severity == _severityFilter)
                        .toList();
                  }
                  if (_statusFilter != 'ALL') {
                    filteredAlerts = filteredAlerts
                        .where((a) => a.status == _statusFilter)
                        .toList();
                  }

                  if (filteredAlerts.isEmpty) {
                    return ListView(
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 80.0, horizontal: 24.0),
                          child: Column(
                            children: [
                              Icon(Icons.notifications_off_outlined, size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                'No matching alerts found',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Pull down to refresh or check your filters.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredAlerts.length,
                    itemBuilder: (context, index) {
                      final alert = filteredAlerts[index];
                      return _AlertTile(alert: alert, isOwner: isOwner);
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
                        Text('Error: $error', textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => ref.invalidate(alertsProvider(null)),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertTile extends ConsumerWidget {
  final dynamic alert;
  final bool isOwner;

  const _AlertTile({required this.alert, required this.isOwner});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resolutionState = ref.watch(alertResolutionProvider);
    final isResolved = alert.status == 'RESOLVED';
    final authState = ref.watch(authProvider);
    final canResolve = authState.role == 'FARMER' &&
        authState.userProfile != null &&
        alert.zoneId != null &&
        authState.userProfile!.assignedZones.contains(alert.zoneId);

    Color severityColor;
    IconData icon;

    switch (alert.severity) {
      case 'CRITICAL':
        severityColor = Theme.of(context).extension<SensorColors>()?.critical ?? Colors.red;
        icon = Icons.error_outline;
        break;
      case 'WARNING':
        severityColor = Theme.of(context).extension<SensorColors>()?.warning ?? Colors.orange;
        icon = Icons.warning_amber_outlined;
        break;
      default:
        severityColor = Colors.blue;
        icon = Icons.info_outline;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: severityColor, width: 6)),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(icon, color: severityColor, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        alert.severity,
                        style: TextStyle(
                          color: severityColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isResolved ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      alert.status,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isResolved ? Colors.green.shade700 : Colors.red.shade700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                alert.message,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                'Zone: ${alert.zoneName ?? "Unknown Zone"}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              if (alert.triggeredValue != null && alert.thresholdValue != null) ...[
                const SizedBox(height: 6),
                Builder(
                  builder: (context) {
                    String getUnit(String? type) {
                      if (type == null) return '';
                      if (type.contains('TEMP')) return '°C';
                      if (type.contains('HUMIDITY')) return '%';
                      if (type.contains('NH3')) return ' ppm';
                      if (type.contains('LPG')) return ' ppm';
                      return '';
                    }
                    final unit = getUnit(alert.type);
                    return Text(
                      'Reading: ${alert.triggeredValue}$unit (Limit: ${alert.thresholdValue}$unit)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }
                ),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Raised: ${DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.tryParse(alert.createdAt)?.toLocal() ?? DateTime.now())}',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  if (alert.resolvedAt != null)
                    Text(
                      'Resolved: ${DateFormat('hh:mm a').format(DateTime.tryParse(alert.resolvedAt!)?.toLocal() ?? DateTime.now())}',
                      style: const TextStyle(fontSize: 11, color: Colors.green),
                    ),
                ],
              ),
              if (!isResolved && canResolve) ...[
                const Divider(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: resolutionState.isLoading
                        ? null
                        : () {
                            ref
                                .read(alertResolutionProvider.notifier)
                                .resolveAlert(alert.id, null);
                          },
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Resolve Alert'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: severityColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(120, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
