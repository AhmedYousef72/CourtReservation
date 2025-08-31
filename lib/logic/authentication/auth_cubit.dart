import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/user.dart';
import '../../data/datasources/auth_remote_datasource.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String? name;
  final String? phoneNumber;

  const SignUpRequested({
    required this.email,
    required this.password,
    this.name,
    this.phoneNumber,
  });

  @override
  List<Object?> get props => [email, password, name, phoneNumber];
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignOutRequested extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final AppUser user;
  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit - Real Firebase Authentication
class AuthCubit extends Cubit<AuthState> {
  final AuthRemoteDataSource _authDataSource;

  AuthCubit({AuthRemoteDataSource? authDataSource})
    : _authDataSource = authDataSource ?? AuthRemoteDataSource(),
      super(AuthInitial()) {
    // Listen to auth state changes with error handling
    try {
      _authDataSource.authStateChanges.listen(
        (user) {
          if (user != null) {
            print('AuthCubit: User authenticated: ${user.email}');
            emit(Authenticated(user));
          } else {
            print('AuthCubit: User unauthenticated');
            emit(Unauthenticated());
          }
        },
        onError: (error) {
          print('Auth state listener error: $error');
          emit(Unauthenticated());
        },
      );
    } catch (e) {
      print('Error setting up auth state listener: $e');
      emit(Unauthenticated());
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    String? name,
    String? phoneNumber,
  }) async {
    emit(AuthLoading());
    try {
      print('Attempting to sign up user: $email');
      await _authDataSource.signUp(
        email: email,
        password: password,
        name: name,
        phoneNumber: phoneNumber,
      );
      print('Sign up successful');
      // Auth state listener will handle the state change
    } catch (e) {
      print('Sign up error: $e');
      print('Error type: ${e.runtimeType}');
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      print('Attempting to sign in user: $email');
      await _authDataSource.signIn(email: email, password: password);
      print('Sign in successful');
      // Auth state listener will handle the state change
    } catch (e) {
      print('Sign in error: $e');
      print('Error type: ${e.runtimeType}');
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
      await _authDataSource.signOut();
      // Auth state listener will handle the state change
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  AppUser? get currentUser => _authDataSource.currentUser;
}
