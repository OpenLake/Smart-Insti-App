import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart'; // Add this import
import 'package:smart_insti_app/theme/ultimate_theme.dart'; // Add theme import
import 'package:smart_insti_app/constants/constants.dart';
import 'package:smart_insti_app/routes/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: SmartInstiApp()));
}

class SmartInstiApp extends StatelessWidget {
  const SmartInstiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      theme: UltimateTheme.themeData,
      routerConfig: routes,
    );
  }
}
