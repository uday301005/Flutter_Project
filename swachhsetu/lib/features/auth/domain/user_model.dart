import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImageId,
    this.address,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profileImageId;
  final String? address;

  @override
  List<Object?> get props => [id, name, email, phone, profileImageId, address];
}
