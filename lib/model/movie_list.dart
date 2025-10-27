class MovieList {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String releaseDate;
  final double rating;
  final double priceIDR;
  double? priceUSD;
  String showtimeWIB;
  String? showtimeWIT;
  String? showtimeWITA;

  MovieList({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.rating,
    this.priceIDR = 45000,
    this.priceUSD,
    this.showtimeWIB = "16:00",
    this.showtimeWIT,
    this.showtimeWITA,
  });

  factory MovieList.fromJson(Map<String, dynamic> json) {
    return MovieList(
      id: json['id'], 
      title: json['title'] ?? '', 
      overview: json['overview'] ?? '', 
      posterPath: json['poster_path'] ?? '', 
      releaseDate: json['release_date'] ?? '', 
      rating: (json['vote_average'] ?? 0).toDouble()
      );
  }

  static Future? getMovieData() async {}
}