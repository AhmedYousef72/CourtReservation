import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/profile/profile_screen.dart';
import 'logic/navigation/nav_cubit.dart';
import 'logic/reservation/reservation_cubit.dart';
import 'logic/court/court_cubit.dart';
import 'logic/authentication/auth_cubit.dart';
import 'data/datasources/court_remote_datasource.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');

    // Initialize sample court data
    try {
      print('Main: Starting court data initialization...');
      final courtDataSource = CourtRemoteDataSource();
      await courtDataSource.initializeSampleData();
      print('Main: Sample court data initialized successfully');
    } catch (e) {
      print('Main: Error initializing sample court data: $e');
      print('Main: Error details: ${e.toString()}');
    }
  } catch (e) {
    print('Error initializing Firebase: $e');
    // Continue without Firebase
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => NavCubit()),
        BlocProvider(create: (_) => ReservationCubit()),
        BlocProvider(create: (_) => CourtCubit()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return BlocBuilder<NavCubit, int>(
                builder: (context, navIndex) {
                  if (navIndex == 3) {
                    // Profile tab selected
                    return const ProfileScreen();
                  } else {
                    // Other tabs (Catalog, Favorites, Reserves)
                    return const HomeScreen();
                  }
                },
              );
            } else if (state is AuthLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else {
              return const LoginScreen();
            }
          },
        ),
      ),
    );
  }
}
