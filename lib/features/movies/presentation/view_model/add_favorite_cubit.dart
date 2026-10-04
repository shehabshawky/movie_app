import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/api/profile_service.dart';
import 'package:movie_app/model/get_all_favorite_model.dart';

part 'add_favorite_state.dart';

class AddFavoriteCubit extends Cubit<AddFavoriteState> {
  AddFavoriteCubit() : super(AddFavoriteInitial());

  bool _isFavorite = false;
  bool get isFavorite => _isFavorite;

  @override
  void emit(AddFavoriteState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  Future<void> toggleFavorite({
    required int movieId,
    required String name,
    required double rating,
    required String imageURL,
    required String year,
  }) async {
    emit(AddFavoriteLoading());
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // 1. Firebase Firestore Mode
      try {
        final favRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('favorites')
            .doc(movieId.toString());

        if (_isFavorite) {
          await favRef.delete();
          _isFavorite = false;
          emit(AddFavoriteRemoved());
        } else {
          await favRef.set({
            'movieId': movieId.toString(),
            'name': name,
            'rating': rating,
            'imageURL': imageURL,
            'year': year,
            'createdAt': FieldValue.serverTimestamp(),
          });
          _isFavorite = true;
          emit(AddFavoriteSuccess(isFavorite: true));
        }

        // Try REST API in background if available
        try {
          if (_isFavorite) {
            await ProfileService.addFavorite(
              movieId: movieId.toString(),
              name: name,
              rating: rating,
              imageURL: imageURL,
              year: year,
            );
          } else {
            await ProfileService.removeFavorite(movieId: movieId);
          }
        } catch (_) {}
      } catch (e) {
        emit(AddFavoriteError(errorMessage: e.toString()));
      }
    } else {
      // 2. REST API Mode
      try {
        if (_isFavorite) {
          await ProfileService.removeFavorite(movieId: movieId);
          _isFavorite = false;
          emit(AddFavoriteRemoved());
        } else {
          await ProfileService.addFavorite(
            movieId: movieId.toString(),
            name: name,
            rating: rating,
            imageURL: imageURL,
            year: year,
          );
          _isFavorite = true;
          await checkIfFavorite(movieId);
          emit(AddFavoriteSuccess(isFavorite: _isFavorite));
        }
      } catch (e) {
        emit(AddFavoriteError(errorMessage: e.toString()));
      }
    }
  }

  Future<bool> getIsFavorite({required int movieId}) async {
    try {
      emit(GetFavoriteLoading());
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('favorites')
            .doc(movieId.toString())
            .get();

        _isFavorite = doc.exists;
        emit(GetFavoriteSuccess(isFavorite: _isFavorite));
        return _isFavorite;
      }

      final response = await ProfileService.getFavorite(movieId: movieId);
      final data = response.data;
      bool isFav = false;
      if (data is Map<String, dynamic>) {
        final val = data["data"];
        if (val is bool) isFav = val;
        if (val is int) isFav = val != 0;
        if (val is String) isFav = val.toLowerCase() == 'true' || val == '1';
      }

      _isFavorite = isFav;
      emit(GetFavoriteSuccess(isFavorite: _isFavorite));
      return isFav;
    } catch (e) {
      emit(GetFavoriteError(errorMessage: e.toString()));
      return false;
    }
  }

  List<Data>? favoriteList;

  Future<void> getAllFavoriteData() async {
    try {
      emit(GetAllFavoriteLoading());
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('favorites')
            .get();

        final list = snapshot.docs.map((doc) {
          final data = doc.data();
          final num? ratingNum = data['rating'] as num?;
          return Data(
            movieId: data['movieId']?.toString() ?? doc.id,
            name: data['name'] as String?,
            rating: ratingNum?.toDouble(),
            imageURL: data['imageURL'] as String?,
            year: data['year']?.toString(),
          );
        }).toList();

        favoriteList = list;
        emit(GetAllFavoriteSuccess(favoriteList: favoriteList!));
        return;
      }

      final response = await ProfileService.getAllFavorite();

      if (response.statusCode == 200) {
        final result = GetAllFavoriteModel.fromJson(response.data);
        favoriteList = result.data ?? [];
        emit(GetAllFavoriteSuccess(favoriteList: favoriteList!));
      } else {
        emit(
          GetAllFavoriteError(
            errorMessage: "Failed with status: ${response.statusCode}",
          ),
        );
      }
    } catch (e) {
      emit(
        GetAllFavoriteError(
          errorMessage: 'Something Went Wrong: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> checkIfFavorite(int movieId) async {
    final isFav = await getIsFavorite(movieId: movieId);
    _isFavorite = isFav;
    log('Favorite status for movie $movieId: $_isFavorite');
    emit(AddFavoriteChecked(isFavorite: _isFavorite));
  }
}
