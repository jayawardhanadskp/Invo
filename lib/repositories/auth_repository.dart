import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:invo/models/user_model.dart';
import 'package:invo/services/database_service.dart';
import 'package:invo/utils/constant.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final Dio _dio = Dio();

  Future<UserModel> signInWithGoogle() async {
  try {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Google sign-in aborted by user');
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    final idToken = await userCredential.user?.getIdToken();

    if (idToken == null) {
      throw Exception('Failed to retrieve ID token');
    }

    await DatabaseService().saveToken(idToken);

    await _dio.post(
      '${Constant.baseUrl}/${Constant.apiVersion}/auth/google-signin',
      options: Options(
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        },
      ),
    );

    final firebaseUser = userCredential.user!;
    return UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName ?? '',
      image: firebaseUser.photoURL ?? '',
    );

  } catch (e) {
    throw Exception('Failed to sign in with Google: $e');
  }
}


  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      final idToken = await user.getIdToken(true);
      if (idToken == null) {
        throw Exception('Failed to retrieve ID token');
      }
      await DatabaseService().saveToken(idToken);

      return UserModel(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? '',
        image: user.photoURL ?? '',
      );
    }
    return null;
  }
}
