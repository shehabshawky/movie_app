import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String avatar,
  });
  Future<void> resetPassword({required String email});
  Future<UserModel?> signInWithGoogle();
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth? firebaseAuth;
  final GoogleSignIn? googleSignIn;
  final FirebaseFirestore? firestore;

  AuthRemoteDataSourceImpl({
    this.firebaseAuth,
    this.googleSignIn,
    this.firestore,
  });

  FirebaseAuth get auth => firebaseAuth ?? FirebaseAuth.instance;
  GoogleSignIn get googleAuth => googleSignIn ?? GoogleSignIn( );
  FirebaseFirestore get db => firestore ?? FirebaseFirestore.instance;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user!;

      String name = user.displayName ?? email.split('@').first;
      String? avatar = user.photoURL;
      String? phoneNumber = user.phoneNumber;

      try {
        final doc = await db.collection('users').doc(user.uid).get();
        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;
          name = data['name'] as String? ?? name;
          avatar = data['avatar'] as String? ?? avatar;
          phoneNumber = data['phoneNumber'] as String? ?? phoneNumber;
        }
      } catch (_) {
        // Firestore read optional fallback
      }

      return UserModel(
        id: user.uid,
        name: name,
        email: user.email ?? email,
        avatar: avatar,
        phoneNumber: phoneNumber,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Login failed: ${e.code}');
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String avatar,
  }) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user!;
      await user.updateDisplayName(name);
      await user.updatePhotoURL(avatar);

      // Save user profile directly to Cloud Firestore users collection
      await db.collection('users').doc(user.uid).set({
        'id': user.uid,
        'name': name,
        'email': email,
        'phoneNumber': phone,
        'avatar': avatar,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return UserModel(
        id: user.uid,
        name: name,
        email: user.email ?? email,
        phoneNumber: phone,
        avatar: avatar,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Registration failed: ${e.code}');
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Password reset failed: ${e.code}');
    } catch (e) {
      throw Exception('Password reset failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleAuth.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication gAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      final user = userCredential.user!;

      final String userName = user.displayName ?? googleUser.displayName ?? '';
      final String userEmail = user.email ?? googleUser.email;
      final String? userAvatar = user.photoURL ?? googleUser.photoUrl;

      // Sync Google user with Firestore
      try {
        await db.collection('users').doc(user.uid).set({
          'id': user.uid,
          'name': userName,
          'email': userEmail,
          'avatar': userAvatar,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } catch (_) {}

      return UserModel(
        id: user.uid,
        name: userName,
        email: userEmail,
        avatar: userAvatar,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Google Sign-In failed: ${e.code}');
    } catch (e) {
      throw Exception('Google Sign-In failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await googleAuth.signOut();
    } catch (_) {}
    try {
      await auth.signOut();
    } catch (_) {}
  }
}
