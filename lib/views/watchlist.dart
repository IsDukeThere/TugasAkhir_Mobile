import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_akhir/model/movie_list.dart';

class Watchlist extends StatelessWidget {
  final String username;
  const Watchlist({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final watchlistBox = Hive.box<MovieList>('watchlist');

    return Scaffold(
      appBar: AppBar(title: const Text("Watchlist")),
      body: ValueListenableBuilder(
        valueListenable: watchlistBox.listenable(),
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
}
