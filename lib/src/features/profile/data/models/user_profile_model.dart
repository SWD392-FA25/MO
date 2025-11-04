import '../../domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.email,
    super.userName,
    super.fullName,
    super.phoneNumber,
    super.avatarUrl,
    super.dateOfBirth,
    super.gender,
    super.address,
    required super.role,
    super.isActive,
    required super.createdAt,
    super.updatedAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      userName: json['userName'] ?? json['username'],
      fullName: json['fullName'] ?? json['name'],
      phoneNumber: json['phoneNumber'] ?? json['phone'],
      avatarUrl: json['avatarUrl'] ?? json['avatar'] ?? json['profilePicture'],
      dateOfBirth: json['dateOfBirth'] ?? json['dob'],
      gender: json['gender'],
      address: json['address'],
      role: json['role'] ?? 'Student',
      isActive: json['isActive'] ?? json['active'] ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'userName': userName,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'avatarUrl': avatarUrl,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'address': address,
      'role': role,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  UserProfile toEntity() => UserProfile(
        id: id,
        email: email,
        userName: userName,
        fullName: fullName,
        phoneNumber: phoneNumber,
        avatarUrl: avatarUrl,
        dateOfBirth: dateOfBirth,
        gender: gender,
        address: address,
        role: role,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
