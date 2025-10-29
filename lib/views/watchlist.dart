import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_akhir/model/movie_list.dart';

class Watchlist extends StatefulWidget {
  final String username;
  const Watchlist({super.key, required this.username});

  @override
  State<Watchlist> createState() => _WatchlistState();
}

class _WatchlistState extends State<Watchlist> {
  Future<Box<MovieList>>? watchlistBox;

  @override
  void initState() {
    super.initState();
    watchlistBox = Hive.openBox<MovieList>('watchlist_${widget.username}');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Box<MovieList>>(
      future: watchlistBox,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("Terjadi kesalahan: ${snapshot.error}")),
          );
        }

    final box = snapshot.data!;
    return Scaffold(
      appBar: AppBar(title: Text("Watchlist ${widget.username}")),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<MovieList> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text("Belum ada film di Watchlist"));
          }

          final movies = box.values.toList();

          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final m = movies[index];
              return ListTile(
                leading: Image.network(
                  "https://image.tmdb.org/t/p/w200${m.posterPath}",
                  fit: BoxFit.cover,
                ),
                title: Text(m.title),
                subtitle: Text("Rating: ${m.rating.toStringAsFixed(1)}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    box.delete(m.id);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
  );
}
}