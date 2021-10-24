import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_bloc/config/paths.dart';
import 'package:insta_bloc/models/post_model.dart';
import 'package:insta_bloc/models/comment_model.dart';
import 'package:insta_bloc/repositories/post/base_post_repository.dart';

class PostRepository implements BasePostRepository {
  final FirebaseFirestore _firebaseFirestore;

  PostRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createPost({required Post post}) async {
    await _firebaseFirestore.collection(Paths.posts).add(post.toDocument());
  }

  @override
  Future<void> createComment({required Comment comment}) async {
    await _firebaseFirestore
        .collection(Paths.comments)
        .doc(comment.postId)
        .collection(Paths.postComments)
        .add(comment.toDocument());
  }

  @override
  Stream<List<Future<Post?>>> getUserPosts({required String user}) {
    final authorRef = _firebaseFirestore.collection(Paths.users).doc(user);
    return _firebaseFirestore
        .collection(Paths.posts)
        .where('author', isEqualTo: authorRef)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => Post.fromDocument(doc)).toList());
  }

  @override
  Stream<List<Future<Comment?>>> getUserComment({required String postId}) {
    return _firebaseFirestore
        .collection(Paths.comments)
        .doc(postId)
        .collection(Paths.postComments)
        .orderBy('date', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Comment.fromDocument(doc)).toList());
  }

  @override
  Future<List<Post?>> getUserFeed({required String userId}) async {
    final postSnap = await _firebaseFirestore
        .collection(Paths.feeds)
        .doc(userId)
        .collection(Paths.userFeed)
        .orderBy('date', descending: true)
        .get();
    final posts = Future.wait(
        postSnap.docs.map((doc) => Post.fromDocument(doc)).toList());
    return posts;
  }
}
