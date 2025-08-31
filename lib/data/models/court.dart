import 'package:equatable/equatable.dart';

class Court extends Equatable {
  final String id;
  final String name;
  final String imagePath;
  final double price;
  final String location;
  final String description;
  final bool isAvailable;
  final List<String> amenities;
  final String sportType;
  final double rating;
  final int reviewCount;

  const Court({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.price,
    required this.location,
    required this.description,
    this.isAvailable = true,
    this.amenities = const [],
    this.sportType = 'Multi-sport',
    this.rating = 0.0,
    this.reviewCount = 0,
  });

  factory Court.fromMap(Map<String, dynamic> map, String id) {
    return Court(
      id: id,
      name: map['name'] ?? '',
      imagePath: map['imagePath'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      location: map['location'] ?? '',
      description: map['description'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
      amenities: List<String>.from(map['amenities'] ?? []),
      sportType: map['sportType'] ?? 'Multi-sport',
      rating: (map['rating'] ?? 0.0).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imagePath': imagePath,
      'price': price,
      'location': location,
      'description': description,
      'isAvailable': isAvailable,
      'amenities': amenities,
      'sportType': sportType,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }

  Court copyWith({
    String? id,
    String? name,
    String? imagePath,
    double? price,
    String? location,
    String? description,
    bool? isAvailable,
    List<String>? amenities,
    String? sportType,
    double? rating,
    int? reviewCount,
  }) {
    return Court(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      price: price ?? this.price,
      location: location ?? this.location,
      description: description ?? this.description,
      isAvailable: isAvailable ?? this.isAvailable,
      amenities: amenities ?? this.amenities,
      sportType: sportType ?? this.sportType,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    imagePath,
    price,
    location,
    description,
    isAvailable,
    amenities,
    sportType,
    rating,
    reviewCount,
  ];
}
