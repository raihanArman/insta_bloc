import 'package:insta_bloc/models/comment_model.dart';
import 'package:insta_bloc/models/models.dart';

abstract class BasePostRepository {
  Future<void> createPost({required Post post});
  Future<void> createComment({required Comment comment});
  Stream<List<Future<Post?>>> getUserPosts({required String user});
  Stream<List<Future<Comment?>>> getUserComment({required String postId});
  Future<List<Post?>> getUserFeed({required String userId});
}
