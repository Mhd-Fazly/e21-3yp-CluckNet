import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/farmers_provider.dart';
import '../../../zones/presentation/providers/zones_provider.dart';
import '../../../shared/data/models/zone_models.dart';

class FarmersManagementScreen extends ConsumerWidget {
  const FarmersManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final farmers = ref.watch(farmersProvider);
    final zonesAsync = ref.watch(zonesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Farm Staff'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddFarmerDialog(context, ref),
        icon: const Icon(Icons.person_add),
        label: const Text('Add Farmer'),
      ),
      body: farmers.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No farmers registered',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: farmers.length,
              itemBuilder: (context, index) {
                final farmer = farmers[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Row(
                      children: [
                        // Avatar
                        CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          child: Text(
                            farmer.username.substring(0, 1).toUpperCase(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Username & Email
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                farmer.username,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                farmer.email,
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                              ),
                              const SizedBox(height: 6),
                              // Assigned Zones Info
                              zonesAsync.when(
                                data: (zones) {
                                  final assigned = zones
                                      .where((z) => farmer.assignedZones.contains(z.id))
                                      .map((z) => z.name)
                                      .toList();
                                  return Text(
                                    assigned.isEmpty
                                        ? 'No zones assigned'
                                        : 'Assigned: ${assigned.join(", ")}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: assigned.isEmpty ? Colors.orange.shade700 : Colors.green.shade700,
                                    ),
                                  );
                                },
                                loading: () => const Text('Loading assignments...', style: TextStyle(fontSize: 12)),
                                error: (_, __) => const Text('Error loading zones', style: TextStyle(fontSize: 12)),
                              ),
                            ],
                          ),
                        ),
                        // Actions
                        IconButton(
                          icon: const Icon(Icons.edit_road_outlined, color: Colors.blue),
                          tooltip: 'Assign Zones',
                          onPressed: () => _showAssignZonesDialog(context, ref, farmer, zonesAsync),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          tooltip: 'Delete Farmer',
                          onPressed: () => _confirmDeleteFarmer(context, ref, farmer.username),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showAddFarmerDialog(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Poultry Farmer'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: usernameController,
                        decoration: const InputDecoration(labelText: 'Username'),
                        validator: (value) => value == null || value.isEmpty ? 'Enter username' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => value == null || !value.contains('@') ? 'Enter a valid email' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: passwordController,
                        decoration: const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        validator: (value) => value == null || value.length < 6 ? 'Password must be >= 6 chars' : null,
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
                              await ref.read(farmersProvider.notifier).addFarmer(
                                    username: usernameController.text.trim(),
                                    email: emailController.text.trim(),
                                    password: passwordController.text,
                                  );
                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Farmer registered successfully.')),
                                );
                              }
                            } catch (e) {
                              setState(() {
                                isLoading = false;
                              });
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error registering farmer: $e'), backgroundColor: Colors.red),
                                );
                              }
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(minimumSize: const Size(80, 40)),
                  child: isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAssignZonesDialog(
    BuildContext context,
    WidgetRef ref,
    FarmerModel farmer,
    AsyncValue<List<ZoneResponse>> zonesAsync,
  ) {
    zonesAsync.when(
      data: (zones) {
        List<int> selectedIds = List<int>.from(farmer.assignedZones);

        showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: Text('Assign Zones to ${farmer.username}'),
                  content: zones.isEmpty
                      ? const Text('No zones available to assign.')
                      : SizedBox(
                          width: double.maxFinite,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: zones.length,
                            itemBuilder: (context, index) {
                              final zone = zones[index];
                              final isSelected = selectedIds.contains(zone.id);

                              return CheckboxListTile(
                                title: Text(zone.name),
                                subtitle: Text(zone.deviceName ?? 'No device'),
                                value: isSelected,
                                onChanged: (val) {
                                  setState(() {
                                    if (val == true) {
                                      selectedIds.add(zone.id);
                                    } else {
                                      selectedIds.remove(zone.id);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                        ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await ref.read(farmersProvider.notifier).assignZones(farmer.username, selectedIds);
                        // Refresh zones list to apply filter if logged in as a farmer
                        ref.invalidate(zonesProvider);
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Zone assignments updated.')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(minimumSize: const Size(80, 40)),
                      child: const Text('Save'),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
      loading: () {},
      error: (_, __) {},
    );
  }

  void _confirmDeleteFarmer(BuildContext context, WidgetRef ref, String username) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove Farmer'),
          content: Text('Are you sure you want to remove "$username"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await ref.read(farmersProvider.notifier).deleteFarmer(username);
                  // Refresh zones in case farmer profile is updated
                  ref.invalidate(zonesProvider);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Farmer removed successfully.')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error removing farmer: $e'), backgroundColor: Colors.red),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, minimumSize: const Size(80, 40)),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }
}
