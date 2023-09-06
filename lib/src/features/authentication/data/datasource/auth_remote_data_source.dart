import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:travel_point/core/constants/constants.dart';
import 'package:travel_point/core/errors/exception.dart';

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
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(
      this._auth, this._firebaseFirestore, this._googleSignIn);

  final FirebaseAuth _auth;
  final FirebaseFirestore _firebaseFirestore;
  final GoogleSignIn _googleSignIn;

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

  //
  // Future<DataMap> _getUserDocument(String userUid) async {
  //   final DocumentReference documentRef = await _getUserDocumentRef(userUid);
  //
  //   final DocumentSnapshot<Object?> userDataFirestore = await documentRef.get();
  //
  //   final data = userDataFirestore.data();
  //
  //   if (data != null) {
  //     return data as DataMap;
  //   } else {
  //     throw const ApiException(
  //         errorMessage: 'No document data found for user!',
  //         errorCode: 'no-document-data');
  //   }
  // }

  @override
  Future<void> loginUser(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
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
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user == null) {
        throw const ApiException(
            errorMessage: 'No user returned from userCredential!',
            errorCode: '500');
      } else {
        await Future.delayed(const Duration(seconds: 3));

        DocumentReference createdUserDocumentRef =
            await _getUserDocumentRef(userCredential.user!.uid);

        Map<String, dynamic> userData = {
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
        Map<String, dynamic> userData =
            documentSnapshot.data() as Map<String, dynamic>;
        String displayName = userData['displayName'] as String;
        displayNames.add(displayName);
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

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      await Future.delayed(const Duration(seconds: 3));

      DocumentReference createdUserDocumentRef =
          await _getUserDocumentRef(userCredential.user!.uid);

      DocumentSnapshot<Object?> document = await createdUserDocumentRef.get();

      final documentData = document.data() as Map<String, dynamic>;

      if (documentData['dateCreated'] == null) {
        Map<String, dynamic> userData = {
          'displayName': userCredential.user!.displayName,
          'emailVerified': false,
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

// @override
// Future<UserModel> getCurrentUser() async {
//   try {
//     User? currentUser = _auth.currentUser;
//     if (currentUser != null) {
//       final userUid = currentUser.uid;
//
//       final data = await _getUserDocument(userUid);
//
//       return UserModel.fromMap(data);
//     } else {
//       throw const ApiException(
//           errorMessage: 'No user is logged in', errorCode: 'no-user');
//     }
//   } on FirebaseException catch (error) {
//     throw ApiException(
//         errorMessage: error.message ?? 'Something went wrong!',
//         errorCode: error.code);
//   }
// }
}
