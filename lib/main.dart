import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/presentation/screens/auth/login_screen.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'injection_container.dart' as di;
import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/screens/home/home_screen.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await di.initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routes: {
        '/home': (_) => const HomeScreen(),
      },
      home: const HomeScreen(),
    );
  }
}

