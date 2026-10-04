import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/api/profile_service.dart';
import 'package:movie_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:movie_app/model/profile_model.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  @override
  void emit(ProfileState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  Future<void> getUser() async {
    emit(GetUserLoadingState());

    String name = '';
    String phone = '';
    int avatarId = 1;
    String email = '';
    String id = '';

    // 1. Check local cache from AuthLocalDataSource
    try {
      final cachedUser = await AuthLocalDataSourceImpl().getCachedUser();
      if (cachedUser != null) {
        if (cachedUser.id.isNotEmpty) id = cachedUser.id;
        if (cachedUser.name.isNotEmpty) name = cachedUser.name;
        if (cachedUser.email.isNotEmpty) email = cachedUser.email;
        if (cachedUser.phoneNumber != null && cachedUser.phoneNumber!.isNotEmpty) {
          phone = cachedUser.phoneNumber!;
        }
        if (cachedUser.avatar != null && cachedUser.avatar!.isNotEmpty) {
          final match = RegExp(r'avatar(\d+)').firstMatch(cachedUser.avatar!);
          if (match != null) {
            avatarId = int.tryParse(match.group(1) ?? '1') ?? 1;
          }
        }
      }
    } catch (_) {}

    // 2. Check Firebase Auth & Cloud Firestore
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      if (id.isEmpty) id = firebaseUser.uid;
      if (email.isEmpty && firebaseUser.email != null) email = firebaseUser.email!;
      if (name.isEmpty && firebaseUser.displayName != null && firebaseUser.displayName!.isNotEmpty) {
        name = firebaseUser.displayName!;
      }
      if (phone.isEmpty && firebaseUser.phoneNumber != null) phone = firebaseUser.phoneNumber!;

      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .get();

        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;
          if (data['name'] != null && data['name'].toString().isNotEmpty) {
            name = data['name'].toString();
          }
          if (data['phoneNumber'] != null && data['phoneNumber'].toString().isNotEmpty) {
            phone = data['phoneNumber'].toString();
          }
          if (data['avaterId'] != null) {
            avatarId = data['avaterId'] as int;
          } else if (data['avatar'] != null) {
            final String avatarStr = data['avatar'].toString();
            final match = RegExp(r'avatar(\d+)').firstMatch(avatarStr);
            if (match != null) {
              avatarId = int.tryParse(match.group(1) ?? '1') ?? 1;
            }
          }
        }
      } catch (_) {}
    }

    if (name.isEmpty && email.isNotEmpty) {
      name = email.split('@').first;
    }

    if (name.isNotEmpty) {
      final profileData = ProfileModel(
        data: Data(
          id: id.isNotEmpty ? id : '1',
          email: email,
          name: name,
          phone: phone,
          avaterId: avatarId,
        ),
      );
      emit(GetUserSuccessState(profileData));
      return;
    }

    // 3. Fallback to REST API
    try {
      final response = await ProfileService.getUser();
      final profileData = ProfileModel.fromJson(response.data);
      emit(GetUserSuccessState(profileData));
    } catch (e) {
      emit(GetUserErrorState(e.toString()));
    }
  }

  Future<void> updateUser({String? name, int? avatarId, String? phone}) async {
    emit(UserUpdateLoadingState());
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      try {
        if (name != null && name.isNotEmpty) {
          await firebaseUser.updateDisplayName(name);
        }

        final Map<String, dynamic> updateMap = {
          'updatedAt': FieldValue.serverTimestamp(),
        };
        if (name != null) updateMap['name'] = name;
        if (phone != null) updateMap['phoneNumber'] = phone;
        if (avatarId != null) {
          updateMap['avaterId'] = avatarId;
          updateMap['avatar'] = 'assets/avatar/avatar$avatarId.png';
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .set(updateMap, SetOptions(merge: true));

        final profileData = ProfileModel(
          data: Data(
            id: firebaseUser.uid,
            email: firebaseUser.email,
            name: name ?? firebaseUser.displayName ?? '',
            phone: phone,
            avaterId: avatarId ?? 1,
          ),
        );

        emit(UserUpdateSuccessState(profileData));

        try {
          await ProfileService.updateUser(
            name: name,
            avatarId: avatarId,
            phone: phone,
          );
        } catch (_) {}
        return;
      } catch (e) {
        emit(UserUpdateErrorState(e.toString()));
        return;
      }
    }

    try {
      final response = await ProfileService.updateUser(
        name: name,
        avatarId: avatarId,
        phone: phone,
      );
      final profileData = ProfileModel.fromJson(response.data);
      emit(UserUpdateSuccessState(profileData));
    } catch (e) {
      emit(UserUpdateErrorState(e.toString()));
    }
  }

  Future<void> deleteUser() async {
    emit(DeleteUserLoadingState());
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .delete();
        await firebaseUser.delete();
        emit(DeleteUserSuccessState());
        return;
      } catch (e) {
        emit(UserUpdateErrorState(e.toString()));
        return;
      }
    }

    try {
      await ProfileService.deleteUser();
      emit(DeleteUserSuccessState());
    } catch (e) {
      emit(UserUpdateErrorState(e.toString()));
    }
  }
}
