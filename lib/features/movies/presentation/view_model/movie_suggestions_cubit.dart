
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/movies/data/models/movie_model.dart';
import 'package:movie_app/features/movies/data/repositories/movie_suggestions_repo.dart';

part 'movie_suggestions_state.dart';

class MovieSuggestionsCubit extends Cubit<MovieSuggestionsState> {
  MovieSuggestionsCubit() : super(MovieSuggestionsInitial());

  getSuggestionsMovies({required int movieId}) async {
    emit(MovieSuggestionsLoading());
    try {
      final suggestionsMovieList = await MovieSuggestionsRepo()
          .getSuggestionsMovies(movieId: movieId);
      emit(MovieSuggestionsSuccess(suggestionsMovies: suggestionsMovieList));
    } catch (e) {
      emit(
        MovieSuggestionsError(message: 'Error fetching suggested movies: $e'),
      );
    }
  }
}