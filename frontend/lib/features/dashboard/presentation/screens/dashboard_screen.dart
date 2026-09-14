import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:clucknet_app/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:clucknet_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:clucknet_app/core/theme/app_theme.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(dashboardSummaryProvider);
    final authState = ref.watch(authProvider);

    final username = authState.username ?? 'User';
    final role = authState.role ?? 'FARMER';
    final isOwner = role == 'OWNER';

    return Scaffold(
      appBar: AppBar(
        title: const Text('CluckNet Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.go('/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(dashboardSummaryProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, $username',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        isOwner ? 'Administrator (Owner)' : 'Poultry Farmer',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  Chip(
                    label: Text(role),
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Farm Status Banner based on summary data
              summaryAsync.when(
                data: (summary) {
                  final hasCritical = summary.criticalAlerts > 0;
                  final hasActive = summary.activeAlerts > 0;

                  Color bannerColor;
                  Color textColor;
                  String title;
                  String subtitle;
                  IconData icon;

                  if (hasCritical) {
                    bannerColor = Theme.of(context).extension<SensorColors>()?.critical.withOpacity(0.15) ?? Colors.red.shade100;
                    textColor = Theme.of(context).extension<SensorColors>()?.critical ?? Colors.red;
                    title = 'CRITICAL STATUS';
                    // subtitle = '${summary.criticalAlerts} zones in danger! Check immediately.';
                    subtitle = 'zones in danger! Check immediately.';
                    icon = Icons.error_outline;
                  } else if (hasActive) {
                    bannerColor = Theme.of(context).extension<SensorColors>()?.warning.withOpacity(0.15) ?? Colors.orange.shade100;
                    textColor = Theme.of(context).extension<SensorColors>()?.warning ?? Colors.orange;
                    title = 'WARNING STATUS';
                    subtitle = '${summary.activeAlerts} climate alerts active.';
                    icon = Icons.warning_amber_outlined;
                  } else {
                    bannerColor = Theme.of(context).extension<SensorColors>()?.safe.withOpacity(0.15) ?? Colors.green.shade100;
                    textColor = Theme.of(context).extension<SensorColors>()?.safe ?? Colors.green;
                    title = 'ALL ZONES SAFE';
                    subtitle = 'Temperatures, humidity, ammonia, and gas are normal.';
                    icon = Icons.check_circle_outline;
                  }

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: bannerColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: textColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(icon, size: 36, color: textColor),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                subtitle,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),

              const SizedBox(height: 24),

              // Summary Grid / Loading / Error
              summaryAsync.when(
                data: (summary) => GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.25,
                  children: [
                    _buildSummaryCard(
                      context,
                      title: 'Poultry Zones',
                      value: summary.totalZones.toString(),
                      icon: Icons.home_work_outlined,
                      iconColor: Colors.blue.shade700,
                      bgColor: Colors.blue.shade50,
                      onTap: () => context.go('/zones'),
                    ),
                    _buildSummaryCard(
                      context,
                      title: 'Active Alerts',
                      value: summary.activeAlerts.toString(),
                      icon: Icons.notifications_active_outlined,
                      iconColor: summary.activeAlerts > 0 ? Colors.red.shade700 : Colors.grey.shade700,
                      bgColor: summary.activeAlerts > 0 ? Colors.red.shade50 : Colors.grey.shade100,
                      onTap: () => context.go('/alerts'),
                    ),
                    _buildSummaryCard(
                      context,
                      title: 'Devices Online',
                      value: summary.onlineDevices.toString(),
                      icon: Icons.wifi,
                      iconColor: Colors.green.shade700,
                      bgColor: Colors.green.shade50,
                    ),
                    _buildSummaryCard(
                      context,
                      title: 'Devices Offline',
                      value: summary.offlineDevices.toString(),
                      icon: Icons.wifi_off,
                      iconColor: summary.offlineDevices > 0 ? Colors.orange.shade700 : Colors.grey.shade700,
                      bgColor: summary.offlineDevices > 0 ? Colors.orange.shade50 : Colors.grey.shade100,
                    ),
                  ],
                ),
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, _) => Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Failed to load dashboard summary: $error',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red.shade900),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => ref.invalidate(dashboardSummaryProvider),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(120, 40),
                          backgroundColor: Colors.red.shade700,
                        ),
                        child: const Text('Retry'),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Shortcut Card for Zones List
              Card(
                child: InkWell(
                  onTap: () => context.go('/zones'),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.thermostat_outlined,
                            color: Theme.of(context).colorScheme.primary,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Monitor Climate Zones',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'View live Temp, Humidity, NH3, and LPG levels.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Owner specific panel shortcut
              if (isOwner) ...[
                Card(
                  child: InkWell(
                    onTap: () => context.push('/owner/farmers'),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.purple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.people_alt_outlined,
                              color: Colors.purple,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Manage Farm Staff',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Create, assign zones, and delete farmer profiles.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: InkWell(
                    onTap: () => context.push('/owner/devices'),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.teal.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.router_outlined,
                              color: Colors.teal,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Manage IoT Devices',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Add, edit, or delete hardware device profiles.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        ],
                      ),
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

  Widget _buildSummaryCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    VoidCallback? onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: bgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: iconColor, size: 22),
                  ),
                  if (onTap != null)
                    const Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
