import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/court.dart';

class CourtRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'courts';

  // Get all courts
  Future<List<Court>> getCourts() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .get();
      return snapshot.docs.map((doc) {
        return Court.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching courts from Firestore: $e');
      // Return empty list if Firestore fails
      return [];
    }
  }

  // Get court by ID
  Future<Court?> getCourtById(String id) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection(_collection)
          .doc(id)
          .get();
      if (doc.exists) {
        return Court.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print('Error fetching court by ID from Firestore: $e');
      return null;
    }
  }

  // Add a new court
  Future<String> addCourt(Court court) async {
    try {
      final DocumentReference docRef = await _firestore
          .collection(_collection)
          .add(court.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add court: $e');
    }
  }

  // Update court
  Future<void> updateCourt(Court court) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(court.id)
          .update(court.toMap());
    } catch (e) {
      throw Exception('Failed to update court: $e');
    }
  }

  // Delete court
  Future<void> deleteCourt(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete court: $e');
    }
  }

  // Initialize with sample data
  Future<void> initializeSampleData() async {
    try {
      print('CourtRemoteDataSource: Starting sample data initialization...');
      final List<Map<String, dynamic>> sampleCourts = [
        {
          'name': 'Court Juan',
          'imagePath': 'assets/court1.png',
          'price': 5.0,
          'location': 'Street 1, City',
          'description':
              'Great court with parking. Perfect for basketball and tennis.',
          'isAvailable': true,
          'amenities': ['Parking', 'Lighting', 'Water Fountain'],
          'sportType': 'Multi-sport',
          'rating': 4.5,
          'reviewCount': 12,
        },
        {
          'name': 'P. Carolina',
          'imagePath': 'assets/court2.png',
          'price': 0.0,
          'location': 'Park, City 170506',
          'description': 'Large park with multiple fields. Free public access.',
          'isAvailable': true,
          'amenities': ['Public Park', 'Multiple Courts', 'Playground'],
          'sportType': 'Multi-sport',
          'rating': 4.2,
          'reviewCount': 8,
        },
        {
          'name': 'Court Zzz',
          'imagePath': 'assets/court3.png',
          'price': 8.0,
          'location': 'Central Ave, City',
          'description': 'Clean surface, good lighting. Professional quality.',
          'isAvailable': true,
          'amenities': [
            'Professional Surface',
            'LED Lighting',
            'Shower Facilities',
          ],
          'sportType': 'Tennis',
          'rating': 4.8,
          'reviewCount': 15,
        },
        {
          'name': 'Court Pepe',
          'imagePath': 'assets/court4.png',
          'price': 3.0,
          'location': 'Calle N-76 1 y, Quito 170120',
          'description': 'Excellent attention and parking. Family friendly.',
          'isAvailable': true,
          'amenities': ['Parking', 'Family Area', 'Snack Bar'],
          'sportType': 'Basketball',
          'rating': 4.3,
          'reviewCount': 10,
        },
        {
          'name': 'Elite Sports Center',
          'imagePath': 'assets/court1.png',
          'price': 12.0,
          'location': 'Sports District, Downtown',
          'description': 'Premium indoor facility with climate control.',
          'isAvailable': true,
          'amenities': [
            'Indoor Facility',
            'Climate Control',
            'Locker Rooms',
            'Pro Shop',
          ],
          'sportType': 'Multi-sport',
          'rating': 4.9,
          'reviewCount': 25,
        },
        {
          'name': 'Community Courts',
          'imagePath': 'assets/court2.png',
          'price': 2.0,
          'location': 'Community Center, Suburbs',
          'description': 'Affordable community courts with basic amenities.',
          'isAvailable': true,
          'amenities': ['Basic Amenities', 'Community Center'],
          'sportType': 'Multi-sport',
          'rating': 4.0,
          'reviewCount': 6,
        },
        {
          'name': 'Sunset Tennis Club',
          'imagePath': 'assets/court3.png',
          'price': 15.0,
          'location': 'Hillside View, West District',
          'description': 'Exclusive tennis club with stunning sunset views.',
          'isAvailable': true,
          'amenities': [
            'Premium Surface',
            'Sunset Views',
            'Club House',
            'Tennis Pro',
          ],
          'sportType': 'Tennis',
          'rating': 4.7,
          'reviewCount': 18,
        },
        {
          'name': 'Urban Basketball Hub',
          'imagePath': 'assets/court4.png',
          'price': 6.0,
          'location': 'Urban Center, Downtown',
          'description': 'Modern basketball facility in the heart of the city.',
          'isAvailable': true,
          'amenities': ['Modern Facility', 'Scoreboards', 'Spectator Seating'],
          'sportType': 'Basketball',
          'rating': 4.4,
          'reviewCount': 14,
        },
        {
          'name': 'Family Sports Complex',
          'imagePath': 'assets/court1.png',
          'price': 4.0,
          'location': 'Family District, North Side',
          'description':
              'Family-oriented sports complex with multiple activities.',
          'isAvailable': true,
          'amenities': ['Family Activities', 'Kids Area', 'Café', 'WiFi'],
          'sportType': 'Multi-sport',
          'rating': 4.6,
          'reviewCount': 22,
        },
        {
          'name': 'University Sports Center',
          'imagePath': 'assets/court2.png',
          'price': 7.0,
          'location': 'University Campus, East District',
          'description': 'University sports center open to the public.',
          'isAvailable': true,
          'amenities': [
            'University Facility',
            'Academic Discounts',
            'Sports Equipment',
          ],
          'sportType': 'Multi-sport',
          'rating': 4.1,
          'reviewCount': 9,
        },
      ];

      print(
        'CourtRemoteDataSource: Sample data prepared, checking existing data...',
      );

      // Check if data already exists
      try {
        final QuerySnapshot existingData = await _firestore
            .collection(_collection)
            .get();
        print(
          'CourtRemoteDataSource: Found ${existingData.docs.length} existing court documents',
        );

        if (existingData.docs.isEmpty) {
          // Add sample data
          print(
            'CourtRemoteDataSource: No existing data found, adding sample courts...',
          );
          for (final courtData in sampleCourts) {
            await _firestore.collection(_collection).add(courtData);
            print('CourtRemoteDataSource: Added court: ${courtData['name']}');
          }
          print(
            'CourtRemoteDataSource: Sample court data initialized successfully!',
          );
        } else {
          print(
            'CourtRemoteDataSource: Court data already exists, skipping initialization.',
          );
        }
      } catch (e) {
        print(
          'CourtRemoteDataSource: Error checking/initializing court data in Firestore: $e',
        );
        // Continue without Firestore initialization
      }
    } catch (e) {
      print('CourtRemoteDataSource: Error in initializeSampleData: $e');
      // Continue without sample data
    }
  }

  // Force re-initialize sample data (clear existing and add new)
  Future<void> forceReinitializeData() async {
    try {
      print('CourtRemoteDataSource: Force re-initializing court data...');

      // First, clear all existing court data
      final QuerySnapshot existingData = await _firestore
          .collection(_collection)
          .get();

      print(
        'CourtRemoteDataSource: Clearing ${existingData.docs.length} existing court documents...',
      );

      for (final doc in existingData.docs) {
        await doc.reference.delete();
      }

      print('CourtRemoteDataSource: All existing court data cleared');

      // Now re-initialize with sample data
      await initializeSampleData();
    } catch (e) {
      print('CourtRemoteDataSource: Error in forceReinitializeData: $e');
    }
  }

  // Manually add a single court (for testing)
  Future<void> addSingleCourt({
    required String name,
    required String imagePath,
    required double price,
    required String location,
    required String description,
  }) async {
    try {
      final courtData = {
        'name': name,
        'imagePath': imagePath,
        'price': price,
        'location': location,
        'description': description,
        'isAvailable': true,
        'amenities': ['Basic Amenities'],
        'sportType': 'Multi-sport',
        'rating': 4.0,
        'reviewCount': 0,
      };

      await _firestore.collection(_collection).add(courtData);
      print('CourtRemoteDataSource: Manually added court: $name');
    } catch (e) {
      print('CourtRemoteDataSource: Error adding single court: $e');
    }
  }
}
