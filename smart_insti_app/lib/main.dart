import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_insti_app/constants/constants.dart';
import 'package:smart_insti_app/routes/routes.dart';

void main() {
  runApp(const SmartInstiApp());
}

class SmartInstiApp extends StatelessWidget {
  const SmartInstiApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return MultiProvider(
    //   providers: [
    //     /// Add Providers here
    //   ],
    return  MaterialApp.router(
        title: AppConstants.name,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppConstants.seedColor),
          useMaterial3: true,
        ),
        routerConfig: routes,
      );
  }
}