import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? phoneNumber;
  final DateTime? createdAt;
  final List<String> favorites;
  final List<String> reservations;

  const AppUser({
    required this.id,
    required this.email,
    this.name,
    this.phoneNumber,
    this.createdAt,
    this.favorites = const [],
    this.reservations = const [],
  });

  factory AppUser.fromMap(Map<String, dynamic> map, String id) {
    return AppUser(
      id: id,
      email: map['email'] ?? '',
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      favorites: List<String>.from(map['favorites'] ?? []),
      reservations: List<String>.from(map['reservations'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt,
      'favorites': favorites,
      'reservations': reservations,
    };
  }

  AppUser copyWith({
    String? id,
    String? email,
    String? name,
    String? phoneNumber,
    DateTime? createdAt,
    List<String>? favorites,
    List<String>? reservations,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      favorites: favorites ?? this.favorites,
      reservations: reservations ?? this.reservations,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    phoneNumber,
    createdAt,
    favorites,
    reservations,
  ];
}
