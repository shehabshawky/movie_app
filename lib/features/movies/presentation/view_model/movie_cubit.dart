import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:movie_app/features/movies/data/models/movie_model.dart';
import 'package:movie_app/features/movies/data/repositories/movie_detalis_repository.dart';

part 'movie_state.dart';

class MovieCubit extends Cubit<MovieState> {
  MovieCubit() : super(MovieInitial());
  final MovieRepository _repository = MovieRepository();
  List<Movies> _allMovies = [];
  List<Movies> _featuredMovies = [];
  List<Movies> _actionMovies = [];

  @override
  void emit(MovieState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  Future<void> getMovies({int page = 1, int limit = 50}) async {
    emit(MovieLoadingState());
    try {
      final List<Movies> movies = await _repository.getMovies(
        page: page,
        limit: limit,
      );
      if (movies.isEmpty) {
        emit(MovieEmptyState('NO INTERNET !'));
        return;
      }

      _allMovies = movies;
      _featuredMovies = movies.toList();
      _actionMovies = movies.toList();
      emit(MovieSuccessState(featured: _featuredMovies, action: _actionMovies));
      limit++;
      _allMovies.addAll(movies.toList());
    } catch (e) {
      emit(MovieErrorState(e.toString()));
    }
  }

  Future<void> getSearchOnMovies({
    required String search,
    int limit = 20,
  }) async {
    emit(MovieLoadingState());
    try {
      final result = await _repository.searchOnMovies(
        search: search,
        limit: limit,
      );
      if (result.isEmpty) {
        emit(MovieEmptyState('Not Found Movie'));
        return;
      }
      emit(SearchSuccessState(movieList: result));
    } catch (e) {
      emit(MovieErrorState(e.toString()));
    }
  }

  void clearSearch() {
    emit(MovieInitial());
  }
}
