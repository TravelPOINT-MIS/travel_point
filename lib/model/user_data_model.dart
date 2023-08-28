import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String? displayName;
  final Timestamp? dateCreated;
  final Timestamp? dateModified;
  final bool isGoogleUser;

  UserData({
    required this.displayName,
    required this.dateCreated,
    required this.dateModified,
    required this.isGoogleUser,
  });

  UserData.defaultValuesGoogleUser({
    this.displayName,
    this.dateCreated,
    this.dateModified,
    this.isGoogleUser = true,
  });

  UserData.defaultValuesNonGoogleUser({
    required this.displayName,
    this.dateModified,
    this.isGoogleUser = false,
  }) : dateCreated = Timestamp.now();

  Map<String, dynamic> toJson() {
    return {
      "displayName": displayName,
      "dateCreated": dateCreated,
      "dateModified": dateModified,
      "isGoogleUser": isGoogleUser,
    };
  }

  factory UserData.fromDocument(DocumentSnapshot<Object?> fireStoreDocument) {
    final userDataFireStoreData = fireStoreDocument.data();

    if (userDataFireStoreData != null) {
      final userDataFireStore = userDataFireStoreData as Map<String, dynamic>;

      final userMetadata = UserData(
          displayName: userDataFireStore['displayName'],
          dateCreated: userDataFireStore['dateCreated'],
          dateModified: userDataFireStore['dateModified'],
          isGoogleUser: userDataFireStore['isGoogleUser'] ?? false);

      return userMetadata;
    }

    return UserData.defaultValuesNonGoogleUser(displayName: 'N/A');
  }
}
