import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:insta_bloc/config/paths.dart';
import 'package:insta_bloc/models/models.dart';
import 'package:insta_bloc/repositories/auth/base_auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class AuthRepository extends BaseAuthRepository {
  final FirebaseFirestore _firebaseFirestore;
  final auth.FirebaseAuth _firebaseAuth;

  AuthRepository(
      {FirebaseFirestore? firebaseFirestore, auth.FirebaseAuth? firebaseAuth})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance;

  @override
  Future<auth.User> logInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user!;
    } on auth.FirebaseAuthException catch (err) {
      throw Failure(code: err.code, message: err.message!);
    } on PlatformException catch (err) {
      throw Failure(code: err.code, message: err.message!);
    }
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<auth.User> signUpWithEmailAndPassword(
      {required String username,
      required String email,
      required String password}) async {
    try {
      final credenctial = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = credenctial.user;
      _firebaseFirestore.collection(Paths.users).doc(user!.uid).set({
        'username': username,
        'email': email,
        'followers': 0,
        'following': 0
      });
      return user;
    } on auth.FirebaseAuthException catch (err) {
      throw Failure(code: err.code, message: err.message!);
    } on PlatformException catch (err) {
      throw Failure(code: err.code, message: err.message!);
    }
  }

  @override
  Stream<auth.User?> get user => _firebaseAuth.userChanges();
}
