import 'package:insta_bloc/models/models.dart';

abstract class BaseUserRepository {
  Future<User> getUserWithId({required String userId});
  Future<void> updateUser(User user);
}
