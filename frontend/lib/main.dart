import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'core/storage/hive_service.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/network/api_constants.dart';
import 'features/shared/data/services/fcm_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final int now = DateTime.now().millisecondsSinceEpoch;
  final String msgId = message.messageId ?? 'unknown_id';
  debugPrint('[LATENCY_LOG] Stage 6: Notification received on device. Msg ID: $msgId, State: background/terminated, Timestamp: $now');
  
  if (message.data.containsKey('iotReceivedAt')) {
    final iotTime = int.tryParse(message.data['iotReceivedAt'] ?? '');
    if (iotTime != null) {
      debugPrint('[LATENCY_LOG] E2E Latency (AWS IoT to Device Received): ${now - iotTime} ms');
    }
  }
  if (message.data.containsKey('fcmSentAt')) {
    final fcmTime = int.tryParse(message.data['fcmSentAt'] ?? '');
    if (fcmTime != null) {
      debugPrint('[LATENCY_LOG] FCM Delivery Latency (FCM Send to Device Received): ${now - fcmTime} ms');
    }
  }

  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase background init warning: $e");
  }
  debugPrint("Handling background message: $msgId");

  final int displayedTime = DateTime.now().millisecondsSinceEpoch;
  debugPrint('[LATENCY_LOG] Stage 7: Notification displayed on device. Msg ID: $msgId, State: background/terminated, Timestamp: $displayedTime, Presentation Latency: ${displayedTime - now} ms');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase App
  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (e) {
    debugPrint("Firebase initialization skipped: $e");
  }

  // Initialize Hive offline storage box
  await HiveService.init();

  // Detect and set the correct local backend URL (10.0.2.2 for emulator vs localhost for physical device)
  await ApiConstants.detectBaseUrl();

  runApp(
    const ProviderScope(
      child: CluckNetApp(),
    ),
  );
}

class CluckNetApp extends ConsumerWidget {
  const CluckNetApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    // Initialize FCM
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(fcmServiceProvider).init();
    });

    return MaterialApp.router(
      title: 'CluckNet',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Automatically matches system preference
    );
  }
}
