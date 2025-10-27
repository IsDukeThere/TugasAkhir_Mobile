import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_akhir/model/movie_detail.dart';
import 'package:project_akhir/model/movie_list.dart';

class TmdbService {
  final String baseApiUrl = "https://api.themoviedb.org/3/movie/popular";
  final String apiKey = "4c931d475ddef54fa1c5269e06b069bb";

  Future<List<MovieList>> getMovieData({int page = 1}) async {
    final url = "$baseApiUrl?api_key=$apiKey&language=en-US&page=$page";
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      final List movies = data['results'];
      return movies.map(
        (json) => MovieList.fromJson(json)
        ).toList();
    } else {
      throw Exception("Gagal Mengambil Data");
    }
  }

  Future<MovieDetail> getMovieDetail(int movieId) async {
    final String detailApi = "https://api.themoviedb.org/3/movie/$movieId?api_key=4c931d475ddef54fa1c5269e06b069bb&language=en-US&page=1";
    final response = await http.get(Uri.parse(detailApi));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return MovieDetail.fromJson(data);
    } else {
      throw Exception("Gagal mengambil detail film dengan ID $movieId");
    }
  }

  Future<List<MovieList>> searchMovie(String query) async {
    final search = "https://api.themoviedb.org/3/search/movie?api_key=$apiKey&language=en-US&query=$query&page=1&include_adult=false";
    final response =  await http.get(Uri.parse(search));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List movies = data['results'];
      return movies.map((json) => MovieList.fromJson(json)).toList();
    } else {
      throw Exception("Gagal mencari film");
    }
  }
}