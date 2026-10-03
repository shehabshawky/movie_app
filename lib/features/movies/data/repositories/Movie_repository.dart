import 'dart:developer';

import 'package:movie_app/features/movies/data/api/dio_movie_helper.dart';
import 'package:movie_app/features/movies/data/api/movie_endpoints.dart';
import 'package:movie_app/features/movies/data/models/movie_details_model.dart';



class MovieDetailsRepository {
  static Future<Movie?> getMovieDetails({required int movieId}) async {
    final response = await DioMovieHelper.getMovieData(
      url: MovieEndpoints.movieDetailsEndpoint,
      query: {'movie_id': movieId, 'with_images': true, 'with_cast': true},
    );
    if (response.statusCode == 200 && response.data != null) {
      final movieDetails = MovieDetailsModel.fromJson(response.data);
      return movieDetails.data?.movie;
    } else {
      log('Error: ${response.statusCode}');
      return null;
    }
  }
}