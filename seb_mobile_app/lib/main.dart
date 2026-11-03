import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants/app_constants.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enable Immersive Sticky Mode (Kiosk Fullscreen)
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );

  // Set Preferred Screen Orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const ElenaSebApp());
}

class ElenaSebApp extends StatelessWidget {
  const ElenaSebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appFullName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppConstants.primaryBlue,
          primary: AppConstants.primaryBlue,
          secondary: AppConstants.accentGold,
          surface: Colors.white,
        ),
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: AppConstants.backgroundLight,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppConstants.primaryDark,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

