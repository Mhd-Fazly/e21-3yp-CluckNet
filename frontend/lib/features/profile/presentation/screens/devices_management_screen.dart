import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/devices_provider.dart';
import '../../../zones/presentation/providers/zones_provider.dart';
import '../../../shared/data/models/device_models.dart';
import '../../../shared/data/models/zone_models.dart';

class DevicesManagementScreen extends ConsumerWidget {
  const DevicesManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devices = ref.watch(devicesProvider);
    final zonesAsync = ref.watch(zonesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage IoT Devices'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDeviceDialog(context, ref, zonesAsync),
        icon: const Icon(Icons.router),
        label: const Text('Add Device'),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(devicesProvider.notifier).loadDevices(),
        child: devices.isEmpty
            ? SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  alignment: Alignment.center,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.router_outlined, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No IoT devices registered',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Pull down to refresh or add a new device',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  final device = devices[index];
                  final isOnline = device.status.toUpperCase() == 'ONLINE';

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Row(
                        children: [
                          // Device Icon / Status indicator
                          CircleAvatar(
                            backgroundColor: isOnline
                                ? Colors.green.shade50
                                : Colors.grey.shade100,
                            child: Icon(
                              Icons.settings_input_hdmi,
                              color: isOnline ? Colors.green : Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Device Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  device.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'MAC: ${device.id}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    // Status Badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isOnline
                                            ? Colors.green.withOpacity(0.1)
                                            : Colors.grey.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        device.status,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: isOnline ? Colors.green : Colors.grey,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Assigned Zone Info
                                    Text(
                                      device.zoneName != null
                                          ? 'Zone: ${device.zoneName}'
                                          : 'Unassigned',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: device.zoneName != null
                                            ? Colors.green.shade700
                                            : Colors.orange.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Actions
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                            tooltip: 'Edit Device',
                            onPressed: () => _showEditDeviceDialog(context, ref, device),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            tooltip: 'Delete Device',
                            onPressed: () => _confirmDeleteDevice(context, ref, device),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _showAddDeviceDialog(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<ZoneResponse>> zonesAsync,
  ) {
    final formKey = GlobalKey<FormState>();
    final idController = TextEditingController();
    final nameController = TextEditingController();
    int? selectedZoneId;
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Register IoT Device'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: idController,
                        decoration: const InputDecoration(
                          labelText: 'Physical Address (MAC)',
                          hintText: 'e.g. AA:BB:CC:DD:EE:FF',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter MAC address';
                          }
                          final macRegex = RegExp(r'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$');
                          if (!macRegex.hasMatch(value.trim())) {
                            return 'Invalid MAC (e.g. AA:BB:CC:DD:EE:FF)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Device Name'),
                        validator: (value) => value == null || value.trim().isEmpty
                            ? 'Enter device name'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      zonesAsync.when(
                        data: (zones) {
                          final unassignedZones = zones
                              .where((z) => z.deviceId == null)
                              .toList();
                          if (unassignedZones.isEmpty) {
                            return const Text(
                              'All zones currently have linked devices.',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            );
                          }
                          return DropdownButtonFormField<int>(
                            decoration: const InputDecoration(
                              labelText: 'Assign Zone (Optional)',
                            ),
                            value: selectedZoneId,
                            items: unassignedZones.map((zone) {
                              return DropdownMenuItem<int>(
                                value: zone.id,
                                child: Text(zone.name),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                selectedZoneId = val;
                              });
                            },
                          );
                        },
                        loading: () => const CircularProgressIndicator(),
                        error: (_, __) => const Text('Error loading zones'),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              await ref.read(devicesProvider.notifier).addDevice(
                                    id: idController.text.trim().toUpperCase(),
                                    name: nameController.text.trim(),
                                    zoneId: selectedZoneId,
                                  );
                              // Invalidate zones to reflect linkage immediately
                              ref.invalidate(zonesProvider);
                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Device registered successfully.'),
                                  ),
                                );
                              }
                            } catch (e) {
                              setState(() {
                                isLoading = false;
                              });
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error registering device: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(minimumSize: const Size(80, 40)),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditDeviceDialog(
    BuildContext context,
    WidgetRef ref,
    DeviceResponse device,
  ) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: device.name);
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Device Details'),
              content: Form(
                key: formKey,
                child: TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Device Name'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Enter device name'
                      : null,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              await ref.read(devicesProvider.notifier).editDevice(
                                    id: device.id,
                                    name: nameController.text.trim(),
                                  );
                              // Invalidate zones to reflect updated name
                              ref.invalidate(zonesProvider);
                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Device updated successfully.'),
                                  ),
                                );
                              }
                            } catch (e) {
                              setState(() {
                                isLoading = false;
                              });
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error updating device: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(minimumSize: const Size(80, 40)),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDeleteDevice(
    BuildContext context,
    WidgetRef ref,
    DeviceResponse device,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Device'),
          content: Text(
            'Are you sure you want to permanently delete device "${device.name}" (${device.id})?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await ref.read(devicesProvider.notifier).deleteDevice(device.id);
                  // Invalidate zones to reflect unlinking
                  ref.invalidate(zonesProvider);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Device deleted successfully.'),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error deleting device: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(80, 40),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
