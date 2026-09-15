import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clucknet_app/features/zones/presentation/screens/threshold_config_screen.dart';
import 'package:clucknet_app/features/zones/presentation/providers/zones_provider.dart';
import 'package:clucknet_app/features/shared/data/models/zone_models.dart';
import 'package:clucknet_app/features/shared/data/models/auth_models.dart';
import 'package:clucknet_app/features/auth/presentation/providers/auth_provider.dart';

class FakeAuthNotifier extends AuthNotifier {
  FakeAuthNotifier(Ref ref, AuthState initialState) : super(ref) {
    state = initialState;
  }

  @override
  Future<void> checkAuthStatus() async {
    // Avoid running checkAuthStatus which uses SharedPreferences/Hive
  }
}

void main() {
  testWidgets('ThresholdConfigScreen shows temp/hum fields when autoThreshold is disabled', (WidgetTester tester) async {
    final thresholdResponse = ThresholdResponse(
      id: 1,
      minTemperature: 20.0,
      maxTemperature: 30.0,
      minHumidity: 40.0,
      maxHumidity: 60.0,
      maxNh3: 20.0,
      maxLpg: 10.0,
      zoneId: 1,
      autoThresholdEnabled: false,
      manualOverrideEnabled: false,
    );

    final scheduleStages = <GrowthScheduleStageResponse>[];

    final authState = AuthState(
      status: AuthStatus.authenticated,
      role: 'FARMER',
      username: 'farmer1',
      userProfile: UserProfileResponse(
        id: 1,
        username: 'farmer1',
        email: 'farmer@example.com',
        role: 'FARMER',
        assignedZones: [1],
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          thresholdProvider(1).overrideWith((ref) => thresholdResponse),
          scheduleProvider(1).overrideWith((ref) => scheduleStages),
          authProvider.overrideWith((ref) => FakeAuthNotifier(ref, authState)),
        ],
        child: const MaterialApp(
          home: ThresholdConfigScreen(zoneId: 1),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Fields should be present
    expect(find.text('Min Temp'), findsOneWidget);
    expect(find.text('Max Temp'), findsOneWidget);
    expect(find.text('Min Humidity'), findsOneWidget);
    expect(find.text('Max Humidity'), findsOneWidget);
  });

  testWidgets('ThresholdConfigScreen hides temp/hum fields when autoThreshold is enabled and manualOverride is disabled', (WidgetTester tester) async {
    final thresholdResponse = ThresholdResponse(
      id: 1,
      minTemperature: 20.0,
      maxTemperature: 30.0,
      minHumidity: 40.0,
      maxHumidity: 60.0,
      maxNh3: 20.0,
      maxLpg: 10.0,
      zoneId: 1,
      autoThresholdEnabled: true,
      manualOverrideEnabled: false,
    );

    final scheduleStages = <GrowthScheduleStageResponse>[];

    final authState = AuthState(
      status: AuthStatus.authenticated,
      role: 'FARMER',
      username: 'farmer1',
      userProfile: UserProfileResponse(
        id: 1,
        username: 'farmer1',
        email: 'farmer@example.com',
        role: 'FARMER',
        assignedZones: [1],
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          thresholdProvider(1).overrideWith((ref) => thresholdResponse),
          scheduleProvider(1).overrideWith((ref) => scheduleStages),
          authProvider.overrideWith((ref) => FakeAuthNotifier(ref, authState)),
        ],
        child: const MaterialApp(
          home: ThresholdConfigScreen(zoneId: 1),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Fields should not be present
    expect(find.text('Min Temp'), findsNothing);
    expect(find.text('Max Temp'), findsNothing);
    expect(find.text('Min Humidity'), findsNothing);
    expect(find.text('Max Humidity'), findsNothing);
  });
}
