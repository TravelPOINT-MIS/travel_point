import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_point/core/errors/exception.dart';

abstract class AuthRemoteDataSource {
  Future<void> loginUser({required String email, required String password});

// Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._auth, this._firebaseFirestore);

  final FirebaseAuth _auth;
  final FirebaseFirestore _firebaseFirestore;

  // Future<DocumentReference> _getUserDocumentRef(String userUid) async {
  //   try {
  //     CollectionReference userCollection =
  //         _firebaseFirestore.collection(FIRESTORE_USER_COLLECTION);
  //
  //     return userCollection.doc(userUid);
  //   } on FirebaseException catch (error) {
  //     throw ApiException(
  //         errorMessage:
  //             error.message ?? 'No document collection found for user!',
  //         errorCode: error.code);
  //   }
  // }
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
          errorMessage: error.message ?? 'Something went wrong!',
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
