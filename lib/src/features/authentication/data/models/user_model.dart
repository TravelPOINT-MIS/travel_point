import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_point/core/type/type_def.dart';
import 'package:travel_point/src/features/authentication/domain/entity/user.dart';

class UserModel extends UserEntity {
  const UserModel(
      {required super.uid,
      required super.displayName,
      required super.email,
      required super.emailVerified,
      required super.dateCreated,
      super.dateModified,
      required super.googleUser});

  UserModel.fromMap(DataMap map)
      : this(
            uid: map['uid'] as String,
            displayName: map['displayName'] as String,
            email: map['email'] as String,
            emailVerified: map['emailVerified'] as bool,
            dateCreated: map['dateCreated'] as Timestamp,
            dateModified: map['dateModified'] as Timestamp,
            googleUser: map['googleUser'] as bool);

}
