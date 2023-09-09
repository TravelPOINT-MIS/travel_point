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
            dateModified: map['dateModified'] != null
                ? map['dateModified'] as Timestamp
                : null,
            googleUser: map['googleUser'] as bool);

  DataMap toDataMap() {
    return {
      'displayName': displayName,
      'emailVerified': emailVerified,
      'dateCreated': dateCreated,
      'dateModified': dateModified,
      'googleUser': googleUser,
    };
  }

  UserModel copyWith({
    String? displayName,
    bool? emailVerified,
    Timestamp? dateCreated,
    Timestamp? dateModified,
    bool? googleUser,
  }) {
    return UserModel(
      uid: uid,
      displayName: displayName ?? this.displayName,
      email: email,
      emailVerified: emailVerified ?? this.emailVerified,
      dateCreated: dateCreated ?? this.dateCreated,
      dateModified: dateModified ?? this.dateModified,
      googleUser: googleUser ?? this.googleUser,
    );
  }

  UserModel.fromUserEntity(UserEntity userEntity)
      : this(
          uid: userEntity.uid,
          displayName: userEntity.displayName,
          email: userEntity.email,
          emailVerified: userEntity.emailVerified,
          dateCreated: userEntity.dateCreated,
          dateModified: userEntity.dateModified,
          googleUser: userEntity.googleUser,
        );
}
