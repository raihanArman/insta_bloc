import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_bloc/config/paths.dart';
import 'package:insta_bloc/models/user_model.dart';
import 'package:insta_bloc/repositories/user/base_user_repository.dart';

class UserRepository extends BaseUserRepository {
  final FirebaseFirestore _firebaseFirestore;

  UserRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<User> getUserWithId({required String userId}) async {
    final doc =
        await _firebaseFirestore.collection(Paths.users).doc(userId).get();
    return doc.exists ? User.fromDocument(doc) : User.empty;
  }

  @override
  Future<void> updateUser(User user) async {
    await _firebaseFirestore
        .collection(Paths.users)
        .doc(user.id)
        .update(user.toDocument());
  }
}
