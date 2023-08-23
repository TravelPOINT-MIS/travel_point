import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_point/model/auth_resp_firebase_model.dart';
import 'package:travel_point/model/user_data_model.dart';
import 'package:travel_point/ui-shared/constants/constants.dart';

class UserService {
  /// Returns the currently authenticated user.
  static User getCurrentUser() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return currentUser;
    } else {
      throw Error();
    }
  }

  /// Registers a new user with the provided email, password, and user data.
  /// Returns an [AuthResponseFirebase] object containing the registration result.
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

  /// Logs in a user with the provided email and password.
  /// Returns an [AuthResponseFirebase] object containing the login result.
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

  /// Returns a [DocumentReference] to the current user's document.
  static Future<DocumentReference> getCurrentUserDocumentRef() async {
    final User currentUser = getCurrentUser();

    return getUserDocumentRef(currentUser.uid);
  }

  /// Returns a [DocumentReference] to a user's document using their UUID.
  static Future<DocumentReference> getUserDocumentRef(String userUuid) async {
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection(FIRESTORE_USER_COLLECTION);

    return userCollection.doc(userUuid);
  }

  /// Updates the current user's document with new user data.
  static Future<void> updateCurrentUserDocument(UserData userData) async {
    final User currentUser = getCurrentUser();

    return await updateUserDocument(currentUser.uid, userData);
  }

  /// Updates a user's document with new user data using their UUID.
  static Future<void> updateUserDocument(
      String userUuid, UserData userData) async {
    DocumentReference userDoc = await getUserDocumentRef(userUuid);

    final Map<String, dynamic> userDataJson = userData.toJson();

    await userDoc.update(userDataJson);
  }

  /// Returns the current user's user data.
  static Future<UserData> getCurrentUserDocument() async {
    final User currentUser = getCurrentUser();

    return await getUserDocument(currentUser.uid);
  }

  /// Returns a user's user data using their UUID.
  static Future<UserData> getUserDocument(String userUuid) async {
    DocumentReference userDoc = await getUserDocumentRef(userUuid);

    final userDataFirestore = await userDoc.get();
    final userMetadata = UserData.fromDocument(userDataFirestore);

    return userMetadata;
  }

  /// Checks if the current user's email is verified.
  static bool isCurrentUserEmailVerified() {
    final User currentUser = getCurrentUser();

    return currentUser.emailVerified;
  }

  /// Checks if the current user's email is verified and returns the result.
  static Future<bool> checkCurrentUserEmailVerified() async {
    final User currentUser = getCurrentUser();

    await currentUser.reload();

    return isCurrentUserEmailVerified();
  }

  /// Sends a verification email to the current user.
  static Future<void> sendCurrentUserVerificationEmail() async {
    final User currentUser = getCurrentUser();

    await currentUser.sendEmailVerification();
  }
}
