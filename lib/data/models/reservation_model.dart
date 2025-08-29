import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum ReservationStatus {
  pending,
  confirmed,
  cancelled,
  completed,
}

class ReservationModel extends Equatable {
  final String id;
  final String userId;
  final String courtId;
  final String courtName;
  final String sportType;
  final DateTime date;
  final String startTime;
  final String endTime;
  final int durationHours;
  final double totalPrice;
  final ReservationStatus status;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ReservationModel({
    required this.id,
    required this.userId,
    required this.courtId,
    required this.courtName,
    required this.sportType,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.durationHours,
    required this.totalPrice,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      courtId: json['courtId'] as String,
      courtName: json['courtName'] as String,
      sportType: json['sportType'] as String,
      date: (json['date'] as Timestamp).toDate(),
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      durationHours: json['durationHours'] as int,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: ReservationStatus.values.firstWhere(
        (e) => e.toString() == 'ReservationStatus.${json['status']}',
        orElse: () => ReservationStatus.pending,
      ),
      notes: json['notes'] as String?,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'courtId': courtId,
      'courtName': courtName,
      'sportType': sportType,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'durationHours': durationHours,
      'totalPrice': totalPrice,
      'status': status.toString().split('.').last,
      'notes': notes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  ReservationModel copyWith({
    String? id,
    String? userId,
    String? courtId,
    String? courtName,
    String? sportType,
    DateTime? date,
    String? startTime,
    String? endTime,
    int? durationHours,
    double? totalPrice,
    ReservationStatus? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReservationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      courtId: courtId ?? this.courtId,
      courtName: courtName ?? this.courtName,
      sportType: sportType ?? this.sportType,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationHours: durationHours ?? this.durationHours,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get statusText {
    switch (status) {
      case ReservationStatus.pending:
        return 'Pending';
      case ReservationStatus.confirmed:
        return 'Confirmed';
      case ReservationStatus.cancelled:
        return 'Cancelled';
      case ReservationStatus.completed:
        return 'Completed';
    }
  }

  Color get statusColor {
    switch (status) {
      case ReservationStatus.pending:
        return Colors.orange;
      case ReservationStatus.confirmed:
        return Colors.green;
      case ReservationStatus.cancelled:
        return Colors.red;
      case ReservationStatus.completed:
        return Colors.blue;
    }
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        courtId,
        courtName,
        sportType,
        date,
        startTime,
        endTime,
        durationHours,
        totalPrice,
        status,
        notes,
        createdAt,
        updatedAt,
      ];
}
