import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:smart_insti_app/theme/ultimate_theme.dart';
import 'package:smart_insti_app/constants/constants.dart';
import 'package:smart_insti_app/routes/routes.dart';
import 'package:smart_insti_app/provider/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL'),
    anonKey: dotenv.get('SUPABASE_ANON_KEY'),
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

  runApp(const ProviderScope(child: SmartInstiApp()));
}

class SmartInstiApp extends ConsumerStatefulWidget {
  const SmartInstiApp({super.key});

  @override
  ConsumerState<SmartInstiApp> createState() => _SmartInstiAppState();
}

class _SmartInstiAppState extends ConsumerState<SmartInstiApp> {
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
