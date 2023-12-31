import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:travel_point/core/constants/constants.dart';
import 'package:travel_point/core/errors/exception.dart';
import 'package:travel_point/core/type/type_def.dart';
import 'package:travel_point/src/features/authentication/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> loginUser({required String email, required String password});

  Future<void> signupUser({
    required String displayName,
    required String email,
    required bool emailVerified,
    required String password,
    required Timestamp dateCreated,
    Timestamp? dateModified,
    required bool googleUser,
  });

  Future<List<String>> getUsernames();

  Future<void> loginWithGoogle();

  Future<void> logoutUser();

  Future<void> sendEmailVerification();

  Future<UserModel> getCurrentUser();

  Future<void> updateUser(UserModel newUser);

  Future<bool> getEmailVerifiedFlag();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(
      this._firebaseAuth, this._firebaseFirestore, this._googleSignIn);

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;
  final GoogleSignIn _googleSignIn;

  Future<User> getCurrentAuthFirebaseUser() async {
    try {
      User? currentUserFirebase = _firebaseAuth.currentUser;

      if (currentUserFirebase == null) {
        throw const ApiException(
            errorMessage: 'No user is logged in!', errorCode: '404');
      } else {
        return currentUserFirebase;
      }
    } on FirebaseException catch (error) {
      throw ApiException(
          errorMessage:
              error.message ?? 'Error while returning current firebase user!',
          errorCode: error.code);
    }
  }

  Future<DocumentReference> _getUserDocumentRef(String userUid) async {
    try {
      CollectionReference userCollection =
          _firebaseFirestore.collection(FIRESTORE_USER_COLLECTION);

      return userCollection.doc(userUid);
    } on FirebaseException catch (error) {
      throw ApiException(
          errorMessage: error.message ?? 'Error while getting user document!',
          errorCode: error.code);
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      User userFirebase = await getCurrentAuthFirebaseUser();

      DocumentReference userDocumentRef =
          await _getUserDocumentRef(userFirebase.uid);
      DocumentSnapshot<Object?> docSnapshot = await userDocumentRef.get();

      DataMap userData = docSnapshot.data() as DataMap;
      UserModel userModel = UserModel.fromMap(userData);

      return userModel;
    } on FirebaseException catch (error) {
      throw ApiException(
          errorMessage:
              error.message ?? 'Error while getting data for current user!',
          errorCode: error.code);
    } on ApiException {
      rethrow;
    }
  }

  @override
  Future<void> loginUser(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (error) {
      throw ApiException(
          errorMessage: error.message ?? 'Error while logging user!',
          errorCode: error.code);
    }
  }

  @override
  Future<void> signupUser(
      {required String displayName,
      required String email,
      required bool emailVerified,
      required String password,
      required Timestamp dateCreated,
      Timestamp? dateModified,
      required bool googleUser}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user == null) {
        throw const ApiException(
            errorMessage: 'No user returned from userCredential!',
            errorCode: '500');
      } else {
        await Future.delayed(const Duration(seconds: 3));

        DocumentReference createdUserDocumentRef =
            await _getUserDocumentRef(userCredential.user!.uid);

        DataMap userData = {
          'displayName': displayName,
          'emailVerified': emailVerified,
          'dateCreated': dateCreated,
          'dateModified': dateModified,
          'googleUser': googleUser,
        };

        await createdUserDocumentRef.update(userData);
      }
    } on FirebaseException catch (error) {
      throw ApiException(
          errorMessage: error.message ?? 'Error while creating user!',
          errorCode: error.code);
    } on ApiException {
      rethrow;
    }
  }

  @override
  Future<List<String>> getUsernames() async {
    try {
      CollectionReference userCollection =
          _firebaseFirestore.collection(FIRESTORE_USER_COLLECTION);

      QuerySnapshot querySnapshot = await userCollection.get();

      List<String> displayNames = [];

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        DataMap userData = documentSnapshot.data() as DataMap;
        UserModel userModel = UserModel.fromMap(userData);
        displayNames.add(userModel.displayName);
      }

      return displayNames;
    } on FirebaseException catch (error) {
      throw ApiException(
          errorMessage: error.message ?? 'Error while getting usernames!',
          errorCode: error.code);
    }
  }

  @override
  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw const ApiException(
            errorMessage: 'Logging with google canceled!',
            errorCode: 'error-logging-google');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      await Future.delayed(const Duration(seconds: 3));

      DocumentReference createdUserDocumentRef =
          await _getUserDocumentRef(userCredential.user!.uid);

      DocumentSnapshot<Object?> document = await createdUserDocumentRef.get();

      final documentData = document.data() as DataMap;

      if (documentData['dateCreated'] == null) {
        DataMap userData = {
          'displayName': userCredential.user!.displayName,
          'emailVerified': userCredential.user!.emailVerified,
          'dateCreated': Timestamp.now(),
          'dateModified': null,
          'googleUser': true,
        };

        await createdUserDocumentRef.update(userData);
      }
    } on FirebaseException catch (error) {
      throw ApiException(
          errorMessage: error.message ?? 'Error while logging with google!',
          errorCode: error.code);
    }
  }

  @override
  Future<void> logoutUser() async {
    try {
      UserModel currentUser = await getCurrentUser();
      bool withGoogleLogin = currentUser.googleUser;

      if (withGoogleLogin) {
        await _googleSignIn.signOut();
      }

      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (error) {
      throw ApiException(
          errorMessage: error.message ?? 'Error while logging out user!',
          errorCode: error.code);
    } on ApiException {
      rethrow;
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      await getCurrentAuthFirebaseUser()
          .then((userFirebase) => userFirebase.sendEmailVerification());
    } on FirebaseException catch (error) {
      throw ApiException(
          errorMessage: error.message ?? 'Error while verifying email!',
          errorCode: error.code);
    } on ApiException {
      rethrow;
    }
  }

  @override
  Future<void> updateUser(UserModel newUser) async {
    try {
      String currentUserId = await getCurrentAuthFirebaseUser()
          .then((userFirebase) => userFirebase.uid);

      DocumentReference createdUserDocumentRef =
          await _getUserDocumentRef(currentUserId);

      await createdUserDocumentRef.update(newUser.toDataMap());
    } on FirebaseException catch (error) {
      throw ApiException(
          errorMessage: error.message ?? 'Error while updating user!',
          errorCode: error.code);
    } on ApiException {
      rethrow;
    }
  }

  @override
  Future<bool> getEmailVerifiedFlag() async {
    try {
      final User user = await getCurrentAuthFirebaseUser();

      user.reload();

      return user.emailVerified;
    } on ApiException {
      rethrow;
    }
  }
}
