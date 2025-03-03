import 'package:flutter/material.dart';
import "package:shootbook/localizations/app_localizations.dart";
import 'package:shootbook/ui/HomeScreen/homescreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'ShootBook',
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
          useMaterial3: true,
          // Define the default brightness and colors.
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blueAccent,
            brightness: Brightness.dark
          ),

      ),
      home: const Scaffold(
        body: HomeScreen(),
      ),
    );}
}
