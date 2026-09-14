import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/zones_provider.dart';
import '../../../../core/network/api_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../shared/data/models/zone_models.dart';

class ThresholdConfigScreen extends ConsumerStatefulWidget {
  final int zoneId;

  const ThresholdConfigScreen({super.key, required this.zoneId});

  @override
  ConsumerState<ThresholdConfigScreen> createState() => _ThresholdConfigScreenState();
}

class _ThresholdConfigScreenState extends ConsumerState<ThresholdConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  final _minTempController = TextEditingController();
  final _maxTempController = TextEditingController();
  final _minHumController = TextEditingController();
  final _maxHumController = TextEditingController();
  final _maxNh3Controller = TextEditingController();
  final _maxLpgController = TextEditingController();
  bool _isSaving = false;
  bool _initialized = false;

  bool _autoThresholdEnabled = false;
  bool _manualOverrideEnabled = false;
  DateTime? _placementDate;

  @override
  void dispose() {
    _minTempController.dispose();
    _maxTempController.dispose();
    _minHumController.dispose();
    _maxHumController.dispose();
    _maxNh3Controller.dispose();
    _maxLpgController.dispose();
    super.dispose();
  }

  void _initializeFields(ThresholdResponse threshold) {
    if (!_initialized) {
      _autoThresholdEnabled = threshold.autoThresholdEnabled;
      _manualOverrideEnabled = threshold.manualOverrideEnabled;
      if (threshold.placementDate != null) {
        _placementDate = DateTime.tryParse(threshold.placementDate!);
      }
      final isReadOnly = _autoThresholdEnabled && !_manualOverrideEnabled;
      _minTempController.text = (isReadOnly ? (threshold.activeMinTemperature ?? threshold.minTemperature) : threshold.minTemperature).toString();
      _maxTempController.text = (isReadOnly ? (threshold.activeMaxTemperature ?? threshold.maxTemperature) : threshold.maxTemperature).toString();
      _minHumController.text = (isReadOnly ? (threshold.activeMinHumidity ?? threshold.minHumidity) : threshold.minHumidity).toString();
      _maxHumController.text = (isReadOnly ? (threshold.activeMaxHumidity ?? threshold.maxHumidity) : threshold.maxHumidity).toString();
      _maxNh3Controller.text = threshold.maxNh3.toString();
      _maxLpgController.text = threshold.maxLpg.toString();
      _initialized = true;
    }
  }

  void _updateControllersForState(ThresholdResponse threshold) {
    final isReadOnly = _autoThresholdEnabled && !_manualOverrideEnabled;
    if (isReadOnly) {
      GrowthScheduleStageResponse? activeStage;
      if (_placementDate != null) {
        final age = DateTime.now().difference(_placementDate!).inDays;
        final scheduleAsync = ref.read(scheduleProvider(widget.zoneId));
        scheduleAsync.whenData((stages) {
          activeStage = stages.where((s) => age >= s.startDay && age <= s.endDay).firstOrNull;
        });
      }

      _minTempController.text = (activeStage?.minTemperature ?? threshold.activeMinTemperature ?? threshold.minTemperature).toString();
      _maxTempController.text = (activeStage?.maxTemperature ?? threshold.activeMaxTemperature ?? threshold.maxTemperature).toString();
      _minHumController.text = (activeStage?.minHumidity ?? threshold.activeMinHumidity ?? threshold.minHumidity).toString();
      _maxHumController.text = (activeStage?.maxHumidity ?? threshold.activeMaxHumidity ?? threshold.maxHumidity).toString();
    } else {
      _minTempController.text = threshold.minTemperature.toString();
      _maxTempController.text = threshold.maxTemperature.toString();
      _minHumController.text = threshold.minHumidity.toString();
      _maxHumController.text = threshold.maxHumidity.toString();
    }
  }

  String _formatDate(DateTime dt) {
    return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
  }

  Future<void> _selectPlacementDate(ThresholdResponse threshold) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _placementDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _placementDate) {
      setState(() {
        _placementDate = picked;
        _updateControllersForState(threshold);
      });
    }
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      try {
        await ref.read(apiServiceProvider).updateThresholds(
              widget.zoneId,
              minTemp: double.parse(_minTempController.text),
              maxTemp: double.parse(_maxTempController.text),
              minHum: double.parse(_minHumController.text),
              maxHum: double.parse(_maxHumController.text),
              maxNh3: double.parse(_maxNh3Controller.text),
              maxLpg: double.parse(_maxLpgController.text),
              autoThresholdEnabled: _autoThresholdEnabled,
              placementDate: _placementDate != null ? _formatDate(_placementDate!) : null,
              manualOverrideEnabled: _manualOverrideEnabled,
            );

        ref.invalidate(thresholdProvider(widget.zoneId));
        ref.invalidate(zoneDetailProvider(widget.zoneId));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Thresholds updated successfully.')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        setState(() {
          _isSaving = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update thresholds: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  void _editSchedule(List<GrowthScheduleStageResponse> stages) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return _ScheduleEditBottomSheet(
          zoneId: widget.zoneId,
          initialStages: stages,
          onSaved: () {
            ref.invalidate(scheduleProvider(widget.zoneId));
            ref.invalidate(thresholdProvider(widget.zoneId));
            ref.invalidate(zoneDetailProvider(widget.zoneId));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final thresholdAsync = ref.watch(thresholdProvider(widget.zoneId));
    final authState = ref.watch(authProvider);
    final isOwner = authState.role == 'OWNER';
    final isFarmer = authState.role == 'FARMER';
    final isAssigned = isFarmer &&
        authState.userProfile != null &&
        authState.userProfile!.assignedZones.contains(widget.zoneId);
    final hasEditPermission = isFarmer && isAssigned;

    final tempHumReadOnly = !hasEditPermission || (_autoThresholdEnabled && !_manualOverrideEnabled);
    final gasReadOnly = !hasEditPermission;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configure Thresholds'),
      ),
      body: thresholdAsync.when(
        data: (threshold) {
          if (!_initialized) {
            _initializeFields(threshold);
          }

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!hasEditPermission) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber.shade200, width: 1),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, color: Colors.amber.shade800),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Only the assigned farmer can modify thresholds for this zone.',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const Text(
                    'Define target safety boundaries for the sensor nodes in this zone. Climate deviations will trigger notifications and highlight indicators in red/orange.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  // Auto Threshold Mode for Farmers
                  if (hasEditPermission) ...[
                    Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 24),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Auto Poultry Thresholds',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Switch.adaptive(
                                  value: _autoThresholdEnabled,
                                  onChanged: (val) {
                                    setState(() {
                                      _autoThresholdEnabled = val;
                                      _updateControllersForState(threshold);
                                    });
                                  },
                                ),
                              ],
                            ),
                            if (_autoThresholdEnabled) ...[
                              const SizedBox(height: 12),
                              const Divider(),
                              const SizedBox(height: 12),
                              const Text(
                                'Select Placement Date (Flock Start Date):',
                                style: TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () => _selectPlacementDate(threshold),
                                      icon: const Icon(Icons.calendar_today, size: 18),
                                      label: Text(
                                        _placementDate != null
                                            ? _formatDate(_placementDate!)
                                            : 'Select Date',
                                      ),
                                    ),
                                  ),
                                  if (threshold.chickAge != null) ...[
                                    const SizedBox(width: 16),
                                    Chip(
                                      backgroundColor: Colors.blue.shade50,
                                      label: Text(
                                        'Age: ${threshold.chickAge} days',
                                        style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Manual Override Temp/Hum',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                  Switch.adaptive(
                                    value: _manualOverrideEnabled,
                                    onChanged: (val) {
                                      setState(() {
                                        _manualOverrideEnabled = val;
                                        _updateControllersForState(threshold);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],

                  if (_autoThresholdEnabled && !_manualOverrideEnabled && !isOwner) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200, width: 1),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue.shade700),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Auto Mode active. Temp/Humidity thresholds are automatically set based on chick age.',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  if (!(_autoThresholdEnabled && !_manualOverrideEnabled)) ...[
                    // Temperature
                    _buildSectionHeader('Temperature Limits (°C)'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _minTempController,
                            readOnly: tempHumReadOnly,
                            enabled: !tempHumReadOnly,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: 'Min Temp',
                              filled: tempHumReadOnly,
                              fillColor: tempHumReadOnly ? Colors.grey.shade100 : null,
                            ),
                            validator: tempHumReadOnly ? null : (value) => _validateDouble(value, 'Enter min temp'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _maxTempController,
                            readOnly: tempHumReadOnly,
                            enabled: !tempHumReadOnly,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: 'Max Temp',
                              filled: tempHumReadOnly,
                              fillColor: tempHumReadOnly ? Colors.grey.shade100 : null,
                            ),
                            validator: tempHumReadOnly ? null : (value) {
                              final err = _validateDouble(value, 'Enter max temp');
                              if (err != null) return err;
                              final min = double.tryParse(_minTempController.text) ?? 0.0;
                              final max = double.tryParse(value!) ?? 0.0;
                              if (max <= min) return 'Must be > Min Temp';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Humidity
                    _buildSectionHeader('Humidity Limits (%)'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _minHumController,
                            readOnly: tempHumReadOnly,
                            enabled: !tempHumReadOnly,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: 'Min Humidity',
                              filled: tempHumReadOnly,
                              fillColor: tempHumReadOnly ? Colors.grey.shade100 : null,
                            ),
                            validator: tempHumReadOnly ? null : (value) => _validateDouble(value, 'Enter min humidity'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _maxHumController,
                            readOnly: tempHumReadOnly,
                            enabled: !tempHumReadOnly,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: 'Max Humidity',
                              filled: tempHumReadOnly,
                              fillColor: tempHumReadOnly ? Colors.grey.shade100 : null,
                            ),
                            validator: tempHumReadOnly ? null : (value) {
                              final err = _validateDouble(value, 'Enter max humidity');
                              if (err != null) return err;
                              final min = double.tryParse(_minHumController.text) ?? 0.0;
                              final max = double.tryParse(value!) ?? 0.0;
                              if (max <= min) return 'Must be > Min Hum';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Gas limits
                  _buildSectionHeader('Gas Safety Limits (ppm)'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _maxNh3Controller,
                    readOnly: gasReadOnly,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Max Ammonia (NH₃) limit',
                      filled: gasReadOnly,
                      fillColor: gasReadOnly ? Colors.grey.shade100 : null,
                    ),
                    validator: (value) => _validateDouble(value, 'Enter NH₃ limit'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _maxLpgController,
                    readOnly: true,
                    enabled: false,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Max LPG Gas limit (Fixed)',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      suffixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                      helperText: 'LPG threshold is safety-critical and remains fixed.',
                      helperStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    validator: null,
                  ),
                  const SizedBox(height: 32),

                  // Growth Schedule Section
                  Consumer(
                    builder: (context, ref, child) {
                      final scheduleAsync = ref.watch(scheduleProvider(widget.zoneId));
                      return scheduleAsync.when(
                        data: (stages) {
                          final sortedStages = List<GrowthScheduleStageResponse>.from(stages);
                          sortedStages.sort((a, b) => a.startDay.compareTo(b.startDay));

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildSectionHeader('Poultry Growth Schedule'),
                                  if (hasEditPermission && !tempHumReadOnly)
                                    TextButton.icon(
                                      onPressed: () => _editSchedule(sortedStages),
                                      icon: const Icon(Icons.edit, size: 18),
                                      label: const Text('Edit Schedule'),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: sortedStages.length,
                                itemBuilder: (context, index) {
                                  final stage = sortedStages[index];
                                  String title = "Day ${stage.startDay} - ${stage.endDay}";
                                  if (stage.startDay == 8 && stage.endDay == 14) title = "Week 2 (Day 8 - 14)";
                                  if (stage.startDay == 15 && stage.endDay == 21) title = "Week 3 (Day 15 - 21)";
                                  if (stage.startDay == 22 && stage.endDay == 28) title = "Week 4 (Day 22 - 28)";

                                  final isActive = threshold.chickAge != null &&
                                      threshold.chickAge! >= stage.startDay &&
                                      threshold.chickAge! <= stage.endDay &&
                                      _autoThresholdEnabled &&
                                      !_manualOverrideEnabled;

                                  return Card(
                                    color: isActive ? Colors.green.shade50 : null,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: isActive ? Colors.green : Colors.transparent,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: ListTile(
                                      dense: true,
                                      title: Row(
                                        children: [
                                          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                                          if (isActive) ...[
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: const Text(
                                                'ACTIVE',
                                                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      subtitle: Text(
                                        "Temp: ${stage.minTemperature}°C - ${stage.maxTemperature}°C  |  Hum: ${stage.minHumidity}% - ${stage.maxHumidity}%",
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (e, _) => Text('Error loading schedule: $e'),
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // Submit Button
                  if (hasEditPermission)
                    ElevatedButton(
                      onPressed: _isSaving ? null : _save,
                      child: _isSaving
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                            )
                          : const Text('Save Settings'),
                    ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error loading thresholds: $error')),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  String? _validateDouble(String? value, String errorMsg) {
    if (value == null || value.isEmpty) return errorMsg;
    if (double.tryParse(value) == null) return 'Must be a number';
    return null;
  }
}

class _ScheduleEditBottomSheet extends StatefulWidget {
  final int zoneId;
  final List<GrowthScheduleStageResponse> initialStages;
  final VoidCallback onSaved;

  const _ScheduleEditBottomSheet({
    required this.zoneId,
    required this.initialStages,
    required this.onSaved,
  });

  @override
  State<_ScheduleEditBottomSheet> createState() => _ScheduleEditBottomSheetState();
}

class _ScheduleEditBottomSheetState extends State<_ScheduleEditBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late List<GrowthScheduleStageResponse> _stages;
  bool _isSaving = false;

  final List<TextEditingController> _minTempControllers = [];
  final List<TextEditingController> _maxTempControllers = [];
  final List<TextEditingController> _minHumControllers = [];
  final List<TextEditingController> _maxHumControllers = [];

  @override
  void initState() {
    super.initState();
    _stages = List.from(widget.initialStages);
    _stages.sort((a, b) => a.startDay.compareTo(b.startDay));

    for (var stage in _stages) {
      _minTempControllers.add(TextEditingController(text: stage.minTemperature.toString()));
      _maxTempControllers.add(TextEditingController(text: stage.maxTemperature.toString()));
      _minHumControllers.add(TextEditingController(text: stage.minHumidity.toString()));
      _maxHumControllers.add(TextEditingController(text: stage.maxHumidity.toString()));
    }
  }

  @override
  void dispose() {
    for (var c in _minTempControllers) {
      c.dispose();
    }
    for (var c in _maxTempControllers) {
      c.dispose();
    }
    for (var c in _minHumControllers) {
      c.dispose();
    }
    for (var c in _maxHumControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _saveSchedule(WidgetRef ref) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      final List<GrowthScheduleStageResponse> updatedStages = [];
      for (int i = 0; i < _stages.length; i++) {
        updatedStages.add(GrowthScheduleStageResponse(
          id: _stages[i].id,
          startDay: _stages[i].startDay,
          endDay: _stages[i].endDay,
          minTemperature: double.parse(_minTempControllers[i].text),
          maxTemperature: double.parse(_maxTempControllers[i].text),
          minHumidity: double.parse(_minHumControllers[i].text),
          maxHumidity: double.parse(_maxHumControllers[i].text),
        ));
      }

      try {
        await ref.read(apiServiceProvider).updateScheduleStages(widget.zoneId, updatedStages);
        widget.onSaved();
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Growth schedule updated successfully.')),
          );
        }
      } catch (e) {
        setState(() {
          _isSaving = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update schedule: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 16,
            left: 16,
            right: 16,
          ),
          height: MediaQuery.of(context).size.height * 0.85,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Edit Growth Schedule',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: _stages.length,
                    itemBuilder: (context, index) {
                      final stage = _stages[index];
                      String stageTitle = "Day ${stage.startDay} - ${stage.endDay}";
                      if (stage.startDay == 8 && stage.endDay == 14) {
                        stageTitle = "Week 2 (Day 8 - 14)";
                      } else if (stage.startDay == 15 && stage.endDay == 21) {
                        stageTitle = "Week 3 (Day 15 - 21)";
                      } else if (stage.startDay == 22 && stage.endDay == 28) {
                        stageTitle = "Week 4 (Day 22 - 28)";
                      }

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stageTitle,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _minTempControllers[index],
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      decoration: const InputDecoration(labelText: 'Min Temp (°C)'),
                                      validator: (value) => _validateDouble(value, 'Enter value'),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _maxTempControllers[index],
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      decoration: const InputDecoration(labelText: 'Max Temp (°C)'),
                                      validator: (value) {
                                        final err = _validateDouble(value, 'Enter value');
                                        if (err != null) return err;
                                        final min = double.tryParse(_minTempControllers[index].text) ?? 0.0;
                                        final max = double.tryParse(value!) ?? 0.0;
                                        if (max <= min) return 'Must be > Min';
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _minHumControllers[index],
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      decoration: const InputDecoration(labelText: 'Min Hum (%)'),
                                      validator: (value) => _validateDouble(value, 'Enter value'),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _maxHumControllers[index],
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      decoration: const InputDecoration(labelText: 'Max Hum (%)'),
                                      validator: (value) {
                                        final err = _validateDouble(value, 'Enter value');
                                        if (err != null) return err;
                                        final min = double.tryParse(_minHumControllers[index].text) ?? 0.0;
                                        final max = double.tryParse(value!) ?? 0.0;
                                        if (max <= min) return 'Must be > Min';
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isSaving ? null : () => _saveSchedule(ref),
                  child: _isSaving
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                        )
                      : const Text('Save Schedule'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  String? _validateDouble(String? value, String errorMsg) {
    if (value == null || value.isEmpty) return errorMsg;
    if (double.tryParse(value) == null) return 'Must be a number';
    return null;
  }
}
