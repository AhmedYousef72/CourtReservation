import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CourtModel extends Equatable {
  final String id;
  final String name;
  final String sportType;
  final String description;
  final String location;
  final double pricePerHour;
  final List<String> images;
  final List<String> amenities;
  final Map<String, dynamic> operatingHours;
  final bool isAvailable;
  final double rating;
  final int reviewCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CourtModel({
    required this.id,
    required this.name,
    required this.sportType,
    required this.description,
    required this.location,
    required this.pricePerHour,
    required this.images,
    required this.amenities,
    required this.operatingHours,
    required this.isAvailable,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CourtModel.fromJson(Map<String, dynamic> json) {
    return CourtModel(
      id: json['id'] as String,
      name: json['name'] as String,
      sportType: json['sportType'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      pricePerHour: (json['pricePerHour'] as num).toDouble(),
      images: List<String>.from(json['images'] ?? []),
      amenities: List<String>.from(json['amenities'] ?? []),
      operatingHours: Map<String, dynamic>.from(json['operatingHours'] ?? {}),
      isAvailable: json['isAvailable'] as bool? ?? true,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sportType': sportType,
      'description': description,
      'location': location,
      'pricePerHour': pricePerHour,
      'images': images,
      'amenities': amenities,
      'operatingHours': operatingHours,
      'isAvailable': isAvailable,
      'rating': rating,
      'reviewCount': reviewCount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  CourtModel copyWith({
    String? id,
    String? name,
    String? sportType,
    String? description,
    String? location,
    double? pricePerHour,
    List<String>? images,
    List<String>? amenities,
    Map<String, dynamic>? operatingHours,
    bool? isAvailable,
    double? rating,
    int? reviewCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CourtModel(
      id: id ?? this.id,
      name: name ?? this.name,
      sportType: sportType ?? this.sportType,
      description: description ?? this.description,
      location: location ?? this.location,
      pricePerHour: pricePerHour ?? this.pricePerHour,
      images: images ?? this.images,
      amenities: amenities ?? this.amenities,
      operatingHours: operatingHours ?? this.operatingHours,
      isAvailable: isAvailable ?? this.isAvailable,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        sportType,
        description,
        location,
        pricePerHour,
        images,
        amenities,
        operatingHours,
        isAvailable,
        rating,
        reviewCount,
        createdAt,
        updatedAt,
      ];
}
