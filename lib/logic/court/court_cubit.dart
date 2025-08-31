import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/court.dart';
import '../../data/datasources/court_remote_datasource.dart';

// Events
abstract class CourtEvent extends Equatable {
  const CourtEvent();

  @override
  List<Object?> get props => [];
}

class LoadCourts extends CourtEvent {}

class AddCourt extends CourtEvent {
  final Court court;
  const AddCourt(this.court);

  @override
  List<Object?> get props => [court];
}

class UpdateCourt extends CourtEvent {
  final Court court;
  const UpdateCourt(this.court);

  @override
  List<Object?> get props => [court];
}

class DeleteCourt extends CourtEvent {
  final String id;
  const DeleteCourt(this.id);

  @override
  List<Object?> get props => [id];
}

// States
abstract class CourtState extends Equatable {
  const CourtState();

  @override
  List<Object?> get props => [];
}

class CourtInitial extends CourtState {}

class CourtLoading extends CourtState {}

class CourtLoaded extends CourtState {
  final List<Court> courts;
  const CourtLoaded(this.courts);

  @override
  List<Object?> get props => [courts];
}

class CourtError extends CourtState {
  final String message;
  const CourtError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class CourtCubit extends Cubit<CourtState> {
  final CourtRemoteDataSource _courtDataSource;

  CourtCubit({CourtRemoteDataSource? courtDataSource})
    : _courtDataSource = courtDataSource ?? CourtRemoteDataSource(),
      super(CourtInitial());

  Future<void> loadCourts() async {
    emit(CourtLoading());
    try {
      final courts = await _courtDataSource.getCourts();
      emit(CourtLoaded(courts));
    } catch (e) {
      emit(CourtError(e.toString()));
    }
  }

  Future<void> addCourt(Court court) async {
    try {
      await _courtDataSource.addCourt(court);
      await loadCourts(); // Reload the list
    } catch (e) {
      emit(CourtError(e.toString()));
    }
  }

  Future<void> updateCourt(Court court) async {
    try {
      await _courtDataSource.updateCourt(court);
      await loadCourts(); // Reload the list
    } catch (e) {
      emit(CourtError(e.toString()));
    }
  }

  Future<void> deleteCourt(String id) async {
    try {
      await _courtDataSource.deleteCourt(id);
      await loadCourts(); // Reload the list
    } catch (e) {
      emit(CourtError(e.toString()));
    }
  }

  // Force re-initialize court data
  Future<void> forceReinitializeData() async {
    emit(CourtLoading());
    try {
      print('CourtCubit: Force re-initializing court data...');
      await _courtDataSource.forceReinitializeData();
      print('CourtCubit: Data re-initialized, now loading courts...');
      await loadCourts();
    } catch (e) {
      print('CourtCubit: Error re-initializing data: $e');
      emit(CourtError(e.toString()));
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
      print('CourtCubit: Adding single court: $name');
      await _courtDataSource.addSingleCourt(
        name: name,
        imagePath: imagePath,
        price: price,
        location: location,
        description: description,
      );
      print('CourtCubit: Single court added, reloading courts...');
      await loadCourts();
    } catch (e) {
      print('CourtCubit: Error adding single court: $e');
      emit(CourtError(e.toString()));
    }
  }
}
