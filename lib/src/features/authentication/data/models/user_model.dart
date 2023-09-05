import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_point/core/type/type_def.dart';
import 'package:travel_point/src/features/authentication/domain/entity/user.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.displayName,
    required super.dateCreated,
    super.dateModified,
    required super.googleUser
  });

  UserModel.fromMap(DataMap map)
      : this(
            displayName: map['displayName'] as String,
            dateCreated: map['dateCreated'] as Timestamp,
            dateModified: map['dateModified'] as Timestamp,
            googleUser: map['googleUser'] as bool);

  DataMap toMap() => {
        'displayName': displayName,
        'dateCreated': dateCreated,
        'dateModified': dateModified,
        'googleUser': googleUser
      };
}
