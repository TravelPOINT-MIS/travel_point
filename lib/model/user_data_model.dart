import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String displayName;
  final Timestamp dateCreated;
  final Timestamp? dateModified;
  final bool emailVerified;

  UserData({
    required this.displayName,
    required this.dateCreated,
    this.dateModified,
    required this.emailVerified,
  });

  UserData.withDefaultValues({
    required this.displayName,
    this.dateModified,
    this.emailVerified = false,
  }) : dateCreated = Timestamp.now();

  Map<String, dynamic> toJson() {
    return {
      "displayName": displayName,
      "dateCreated": dateCreated,
      "dateModified": dateModified,
      "emailVerified": emailVerified
    };
  }

  factory UserData.fromDocument(DocumentSnapshot<Object?> fireStoreDocument) {
    final userDataFireStore = fireStoreDocument.data() as Map<String, dynamic>;

    final userMetadata = UserData(
        displayName: userDataFireStore['displayName'],
        dateCreated: userDataFireStore['dateCreated'],
        dateModified: userDataFireStore['dateModified'],
        emailVerified: userDataFireStore['emailVerified']);

    return userMetadata;
  }
}
