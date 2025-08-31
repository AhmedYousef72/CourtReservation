import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'users';

  // Get current user
  AppUser? get currentUser {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        return AppUser(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          name: firebaseUser.displayName,
          phoneNumber: firebaseUser.phoneNumber,
        );
      }
      return null;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  // Stream of auth state changes
  Stream<AppUser?> get authStateChanges {
    try {
      return _auth.authStateChanges().asyncMap((firebaseUser) async {
        if (firebaseUser != null) {
          try {
            // Get user data from Firestore
            final doc = await _firestore
                .collection(_collection)
                .doc(firebaseUser.uid)
                .get();
            if (doc.exists) {
              return AppUser.fromMap(doc.data()!, firebaseUser.uid);
            } else {
              // Create new user document
              final user = AppUser(
                id: firebaseUser.uid,
                email: firebaseUser.email ?? '',
                name: firebaseUser.displayName,
                phoneNumber: firebaseUser.phoneNumber,
                createdAt: DateTime.now(),
              );
              await _firestore
                  .collection(_collection)
                  .doc(firebaseUser.uid)
                  .set(user.toMap());
              return user;
            }
          } catch (e) {
            print('Error fetching user data from Firestore: $e');
            // Return basic user info if Firestore fails
            return AppUser(
              id: firebaseUser.uid,
              email: firebaseUser.email ?? '',
              name: firebaseUser.displayName,
              phoneNumber: firebaseUser.phoneNumber,
              createdAt: DateTime.now(),
            );
          }
        }
        return null;
      });
    } catch (e) {
      print('Error setting up auth state changes: $e');
      // Return a stream that emits null
      return Stream.value(null);
    }
  }

  // Sign up with email and password
  Future<AppUser> signUp({
    required String email,
    required String password,
    String? name,
    String? phoneNumber,
  }) async {
    try {
      print('AuthRemoteDataSource: Starting sign up process');
      print(
        'AuthRemoteDataSource: Firebase Auth instance: ${_auth.toString()}',
      );

      // Create Firebase Auth user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('AuthRemoteDataSource: User credential created successfully');
      final firebaseUser = userCredential.user!;

      // Update display name if provided
      if (name != null) {
        await firebaseUser.updateDisplayName(name);
        print('AuthRemoteDataSource: Display name updated');
      }

      // Create user document in Firestore
      final user = AppUser(
        id: firebaseUser.uid,
        email: email,
        name: name,
        phoneNumber: phoneNumber,
        createdAt: DateTime.now(),
      );

      try {
        await _firestore
            .collection(_collection)
            .doc(firebaseUser.uid)
            .set(user.toMap());
        print('AuthRemoteDataSource: User document created in Firestore');
      } catch (e) {
        print('Error creating user document in Firestore: $e');
        // Continue without Firestore document
      }

      print('AuthRemoteDataSource: Sign up completed successfully');
      return user;
    } catch (e) {
      print('AuthRemoteDataSource: Sign up failed with error: $e');
      print('AuthRemoteDataSource: Error type: ${e.runtimeType}');
      throw Exception('Failed to sign up: $e');
    }
  }

  // Sign in with email and password
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user!;

      try {
        // Get user data from Firestore
        final doc = await _firestore
            .collection(_collection)
            .doc(firebaseUser.uid)
            .get();

        if (doc.exists) {
          return AppUser.fromMap(doc.data()!, firebaseUser.uid);
        } else {
          // Create user document if it doesn't exist
          final user = AppUser(
            id: firebaseUser.uid,
            email: email,
            name: firebaseUser.displayName,
            phoneNumber: firebaseUser.phoneNumber,
            createdAt: DateTime.now(),
          );
          await _firestore
              .collection(_collection)
              .doc(firebaseUser.uid)
              .set(user.toMap());
          return user;
        }
      } catch (e) {
        print('Error fetching user data from Firestore: $e');
        // Return basic user info if Firestore fails
        return AppUser(
          id: firebaseUser.uid,
          email: email,
          name: firebaseUser.displayName,
          phoneNumber: firebaseUser.phoneNumber,
          createdAt: DateTime.now(),
        );
      }
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  // Update user profile
  Future<void> updateProfile({String? name, String? phoneNumber}) async {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser == null) throw Exception('No user logged in');

      // Update Firebase Auth profile
      if (name != null) {
        await firebaseUser.updateDisplayName(name);
      }

      // Update Firestore document
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (phoneNumber != null) updates['phoneNumber'] = phoneNumber;

      try {
        await _firestore
            .collection(_collection)
            .doc(firebaseUser.uid)
            .update(updates);
      } catch (e) {
        print('Error updating user document in Firestore: $e');
        // Continue without Firestore update
      }
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // Get user by ID
  Future<AppUser?> getUserById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists) {
        return AppUser.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  // Add favorite court
  Future<void> addFavorite(String courtId) async {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser == null) throw Exception('No user logged in');

      await _firestore.collection(_collection).doc(firebaseUser.uid).update({
        'favorites': FieldValue.arrayUnion([courtId]),
      });
    } catch (e) {
      throw Exception('Failed to add favorite: $e');
    }
  }

  // Remove favorite court
  Future<void> removeFavorite(String courtId) async {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser == null) throw Exception('No user logged in');

      await _firestore.collection(_collection).doc(firebaseUser.uid).update({
        'favorites': FieldValue.arrayRemove([courtId]),
      });
    } catch (e) {
      throw Exception('Failed to remove favorite: $e');
    }
  }
}
