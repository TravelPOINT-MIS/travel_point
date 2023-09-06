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

  // factory UserData.fromDocument(DocumentSnapshot<Object?> fireStoreDocument) {
  //   final userDataFireStoreData = fireStoreDocument.data();
  //
  //   if (userDataFireStoreData != null) {
  //     final userDataFireStore = userDataFireStoreData as Map<String, dynamic>;
  //
  //     final userMetadata = UserData(
  //         displayName: userDataFireStore['displayName'],
  //         dateCreated: userDataFireStore['dateCreated'],
  //         dateModified: userDataFireStore['dateModified'],
  //         googleUser: userDataFireStore['isGoogleUser'] ?? false);
  //
  //     return userMetadata;
  //   }
  //
  //   return UserData.defaultValuesNonGoogleUser(displayName: 'N/A');
  // }

  @override
  List<Object?> get props => [uid];
}
