import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_akhir/controllers/detail_controller.dart';
import 'package:project_akhir/model/movie_detail.dart';
import 'package:project_akhir/model/movie_list.dart';
import 'package:project_akhir/services/tmdb_service.dart';

class Detail extends StatefulWidget {
  final MovieList movie;
  final int id;
  const Detail({
    super.key, 
    required this.id,
    required this.movie
    });

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  late DetailController controller;
  late Box<MovieList> watchlistBox;
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    controller = DetailController(tmdbService: TmdbService());
    watchlistBox = Hive.box<MovieList>('watchlist');
    _checkIfSaved();
  }

  void _checkIfSaved() {
    setState(() {
      isSaved = watchlistBox.containsKey(widget.movie.id);
    });
  }

  void _toggleWatchlist() {
    if (isSaved) {
      watchlistBox.delete(widget.movie.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${widget.movie.title} dihapus dari Watchlist")),
      );
    } else {
      watchlistBox.put(widget.movie.id, widget.movie);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${widget.movie.title} ditambahkan ke Watchlist")),
      );
    }

    _checkIfSaved();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Film"),
      ),
      body: FutureBuilder<MovieDetail>(
        future: controller.getMovieDetail(widget.id), 
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Data tidak ditemukan"));
          }

          final movie = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network("https:image.tmdb.org/t/p/w500${movie.posterPath}",
                fit: BoxFit.cover,
                width: double.infinity,
                height: 400,
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(movie.title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                      SizedBox(height: 15,),
                      Icon(Icons.star, color: Colors.amber, size: 15),
                      Text(
                        movie.rating.toStringAsFixed(1),
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        "${movie.runtime.toString()} menit"
                        ),
                      Text(
                        "Bahasa : ${movie.language.join(', ')}"
                        ),
                      Text(
                        "Genre: ${movie.genres.join(', ')}"
                        ),
                      SizedBox(height: 25,),
                      Text(
                        movie.overview
                      )
                    ],
                  ),
                  )
              ],
            ),
          );
        }
        ),
        floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggleWatchlist,
        label: Text(isSaved ? "Hapus dari Watchlist" : "Tambah ke Watchlist"),
        icon: Icon(isSaved ? Icons.check : Icons.add),
      ),
    );
  }
}