import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String displayName;
  final String email;
  final bool emailVerified;
  final Timestamp dateCreated;
  final Timestamp? dateModified;
  final bool googleUser;

  const UserEntity({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.emailVerified,
    required this.dateCreated,
    this.dateModified,
    required this.googleUser,
  });

  @override
  List<Object?> get props => [uid];
}
