import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String email;
  final String? userName;
  final String? fullName;
  final String? phoneNumber;
  final String? avatarUrl;
  final String? dateOfBirth;
  final String? gender;
  final String? address;
  final String role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserProfile({
    required this.id,
    required this.email,
    this.userName,
    this.fullName,
    this.phoneNumber,
    this.avatarUrl,
    this.dateOfBirth,
    this.gender,
    this.address,
    required this.role,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        userName,
        fullName,
        phoneNumber,
        avatarUrl,
        dateOfBirth,
        gender,
        address,
        role,
        isActive,
        createdAt,
        updatedAt,
      ];
}
