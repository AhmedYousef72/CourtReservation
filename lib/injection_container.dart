// import 'package:get_it/get_it.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// final GetIt getIt = GetIt.instance;

// Future<void> initializeDependencies() async {
//   // Firebase initialization
//   await Firebase.initializeApp();
  
//   // Firebase services
//   getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
//   getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  
//   // Repositories
//   // getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(getIt()));
//   // getIt.registerLazySingleton<CourtRepository>(() => CourtRepositoryImpl(getIt()));
//   // getIt.registerLazySingleton<ReservationRepository>(() => ReservationRepositoryImpl(getIt()));
//   // getIt.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(getIt()));
  
//   // Cubits
//   // getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt()));
//   // getIt.registerFactory<CourtCubit>(() => CourtCubit(getIt()));
//   // getIt.registerFactory<ReservationCubit>(() => ReservationCubit(getIt()));
//   // getIt.registerFactory<ProfileCubit>(() => ProfileCubit(getIt()));
// }
