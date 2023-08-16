import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_point/ui-shared/constants/firebaseConstants.dart';

class FirestoreUser {
  static Future<DocumentReference> getUserDocumentRef(String userUuid) async {
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection(FIRESTORE_USER_COLLECTION);

    return userCollection.doc(userUuid);
  }

  static Future<void> updateUserDocument(
      String userUuid, Map<String, Object?> userMetadata) async {
    DocumentReference userDoc = await getUserDocumentRef(userUuid);

    await userDoc.update(userMetadata);
  }

  static Future<Map<String, dynamic>> getUserDocument(String userUuid) async {
    DocumentReference userDoc = await getUserDocumentRef(userUuid);

    return await userDoc
        .get()
        .then((value) => value.data() as Map<String, dynamic>);
  }
}
