import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/constants/constants.dart';
import 'package:smart_insti_app/routes/routes.dart';
import 'package:smart_insti_app/services/notification_service.dart';
import 'package:smart_insti_app/provider/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  try {
    await Firebase.initializeApp(); // Initialize Firebase
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }
  runApp(const ProviderScope(child: SmartInstiApp()));
}

class SmartInstiApp extends ConsumerStatefulWidget {
  const SmartInstiApp({super.key});

  @override
  ConsumerState<SmartInstiApp> createState() => _SmartInstiAppState();
}



class _SmartInstiAppState extends ConsumerState<SmartInstiApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(notificationServiceProvider).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      theme: UltimateTheme.lightThemeData,
      darkTheme: UltimateTheme.darkThemeData,
      themeMode: themeMode,
      routerConfig: routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

