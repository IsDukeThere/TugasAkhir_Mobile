import 'package:project_akhir/model/movie_list.dart';
import 'package:project_akhir/services/tmdb_service.dart';

class MovieController {
  final TmdbService tmdbService;
  
  MovieController({
    required this.tmdbService
  });

  Future<List<MovieList>> getMovies({int page = 1}) async {
    final movies = await tmdbService.getMovieData(page: page);
    return movies.map((movies) {
      return MovieList(
        id: movies.id, 
        title: movies.title, 
        overview:  movies.overview, 
        posterPath:  movies.posterPath, 
        releaseDate:  movies.releaseDate, 
        rating:  movies.rating
        );
    }).toList();
  }

  Future<List<MovieList>> searchMovies(String query) async {
    return await tmdbService.searchMovie(query);
  }
}