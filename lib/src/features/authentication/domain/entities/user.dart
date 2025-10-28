import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final String? phoneNumber;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    this.phoneNumber,
  });

  @override
  List<Object?> get props => [id, email, name, avatarUrl, phoneNumber];
}
