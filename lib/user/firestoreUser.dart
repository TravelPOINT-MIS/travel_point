import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_point/ui-shared/constants/firebaseConstants.dart';

class FirestoreUser {
  static Future<void> updateUserDocument(
      String userUuid, Map<String, Object> userMetadata) async {
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection(FIRESTORE_USER_COLLECTION);

    DocumentReference userDoc = userCollection.doc(userUuid);

    await userDoc.update(userMetadata);
  }
}
