import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../presentation/screens/item_detail/item_detail_screen.dart';

class ReservationState {
  final List<ReservationEntry> reservations;
  final bool isLoading;
  final String? error;

  const ReservationState({
    this.reservations = const [],
    this.isLoading = false,
    this.error,
  });

  ReservationState copyWith({
    List<ReservationEntry>? reservations,
    bool? isLoading,
    String? error,
  }) => ReservationState(
    reservations: reservations ?? this.reservations,
    isLoading: isLoading ?? this.isLoading,
    error: error ?? this.error,
  );
}

class ReservationCubit extends Cubit<ReservationState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'reservations';

  ReservationCubit() : super(const ReservationState());

  // Load reservations from Firebase
  Future<void> loadReservations() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      print('ReservationCubit: Loading reservations from Firebase...');
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .orderBy('date', descending: true)
          .get();

      final reservations = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ReservationEntry(
          itemName: data['itemName'] ?? '',
          imagePath: data['imagePath'] ?? '',
          date: (data['date'] as Timestamp).toDate(),
          time: data['time'] ?? '',
          price: (data['price'] ?? 0.0).toDouble(),
        );
      }).toList();

      print('ReservationCubit: Loaded ${reservations.length} reservations');
      emit(state.copyWith(reservations: reservations, isLoading: false));
    } catch (e) {
      print('ReservationCubit: Error loading reservations: $e');
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  // Add reservation to Firebase
  Future<void> addReservation(ReservationEntry entry) async {
    try {
      print('ReservationCubit: Adding reservation to Firebase...');

      // Save to Firebase
      await _firestore.collection(_collection).add({
        'itemName': entry.itemName,
        'imagePath': entry.imagePath,
        'date': Timestamp.fromDate(entry.date),
        'time': entry.time,
        'price': entry.price,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('ReservationCubit: Reservation saved to Firebase successfully');

      // Update local state
      final updated = List<ReservationEntry>.from(state.reservations)
        ..add(entry);
      emit(state.copyWith(reservations: updated));
    } catch (e) {
      print('ReservationCubit: Error adding reservation: $e');
      emit(state.copyWith(error: e.toString()));
    }
  }

  void removeAt(int index) {
    final updated = List<ReservationEntry>.from(state.reservations)
      ..removeAt(index);
    emit(state.copyWith(reservations: updated));
  }

  void clear() => emit(const ReservationState(reservations: []));
}
