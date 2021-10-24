import 'package:insta_bloc/models/models.dart';

abstract class BaseUserRepository {
  Future<User> getUserWithId({required String userId});
  Future<void> updateUser({required User user});
  Future<List<User>> searchUsers({String query});
  void followUser({required String userId, required String followUserId});
  void unfollowUser({required String userId, required String unfollowUserId});
  Future<bool> isFolowing(
      {required String userId, required String otherUserId});
}
