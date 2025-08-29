import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String? phoneNumber;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isEmailVerified;
  final List<String> favoriteSports;

  const UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.phoneNumber,
    this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.isEmailVerified,
    this.favoriteSports = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      favoriteSports: List<String>.from(json['favoriteSports'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isEmailVerified': isEmailVerified,
      'favoriteSports': favoriteSports,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phoneNumber,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isEmailVerified,
    List<String>? favoriteSports,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      favoriteSports: favoriteSports ?? this.favoriteSports,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        fullName,
        phoneNumber,
        profileImageUrl,
        createdAt,
        updatedAt,
        isEmailVerified,
        favoriteSports,
      ];
}
