import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:invo/models/user_model.dart';

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
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      final idToken = await userCredential.user?.getIdToken();
      if (idToken == null) {
        throw Exception('Failed to retrieve ID token');
      }

      final response = await _dio.post(
        'https://us-central1-invo-d4222.cloudfunctions.net/api/auth/google-signin',
        options: Options(
          headers: {
            'Authorization': 'Bearer $idToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to sign in with Google: ${response.statusMessage}',
        );
      }
      final data = jsonDecode(response.data);
      return data;
    } catch (e) {
      print(e);
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  UserModel? getCurrentUser() {
  final user = _firebaseAuth.currentUser;
  if (user != null) {
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
