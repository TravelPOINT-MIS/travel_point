import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_point/model/auth_resp_firebase_model.dart';
import 'package:travel_point/model/user_data_model.dart';
import 'package:travel_point/ui-shared/constants/constants.dart';

class UserService {
  /// Signs up a user with the provided [email], [password], and [userData].
  /// Returns an [AuthResponseFirebase] indicating the result of the sign-up process.
  static Future<AuthResponseFirebase> signUpUser(
      String email, String password, UserData userData) async {
    AuthResponseFirebase authResponseFirebase = AuthResponseFirebase();

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await Future.delayed(const Duration(seconds: 3));

      await UserService.updateUserDocument(userCredential.user!.uid, userData);

      authResponseFirebase.userCredential = userCredential;
    } on FirebaseAuthException catch (error) {
      authResponseFirebase.error = error;
    }

    return authResponseFirebase;
  }

  /// Logs out the currently authenticated user.
  static Future<void> logOutUser() async {
    await FirebaseAuth.instance.signOut();
  }

  /// Logs in a user with the provided [email] and [password].
  /// Returns an [AuthResponseFirebase] indicating the result of the login process.
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

  /// Retrieves the reference to the user document in Firestore based on [userUuid].
  static Future<DocumentReference> getUserDocumentRef(String userUuid) async {
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection(FIRESTORE_USER_COLLECTION);

    return userCollection.doc(userUuid);
  }

  /// Updates the user document with the provided [userData] using [userUuid].
  static Future<void> updateUserDocument(
      String userUuid, UserData userData) async {
    DocumentReference userDoc = await getUserDocumentRef(userUuid);

    final Map<String, dynamic> userDataJson = userData.toJson();

    await userDoc.update(userDataJson);
  }

  /// Retrieves the user data from the Firestore document based on [userUuid].
  static Future<UserData> getUserDocument(String userUuid) async {
    DocumentReference userDoc = await getUserDocumentRef(userUuid);

    final userDataFirestore = await userDoc.get();
    final userMetadata = UserData.fromDocument(userDataFirestore);

    return userMetadata;
  }
}
