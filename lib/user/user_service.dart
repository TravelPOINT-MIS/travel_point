import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_point/model/auth_resp_firebase_model.dart';
import 'package:travel_point/ui-shared/constants/constants.dart';

class UserService {
  static Future<AuthResponseFirebase> signUpUser(
      String displayName, String email, String password) async {
    AuthResponseFirebase authResponseFirebase = AuthResponseFirebase();

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await Future.delayed(const Duration(seconds: 2));

      await UserService.updateUserDocument(userCredential.user!.uid, {
        "displayName": displayName,
        "dateCreated": DateTime.now(),
        "dateModified": null,
        "emailVerified": false
      });

      authResponseFirebase.userCredential = userCredential;
    } on FirebaseAuthException catch (error) {
      authResponseFirebase.error = error;
    }

    return authResponseFirebase;
  }

  static Future<void> logOutUser() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<AuthResponseFirebase> logInUser(
      String email, String password) async {
    AuthResponseFirebase authResponseFirebase = AuthResponseFirebase();

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      authResponseFirebase.userCredential = userCredential;
    } on FirebaseAuthException catch (error) {
      authResponseFirebase.error = error;
    }

    return authResponseFirebase;
  }

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
