import 'package:flutter/material.dart';
import 'package:project_akhir/controllers/movie_controller.dart';
import 'package:project_akhir/model/movie_list.dart';
import 'package:project_akhir/services/tmdb_service.dart';
import 'package:project_akhir/views/detail.dart';
import 'package:intl/intl.dart';
import 'package:project_akhir/views/login.dart';

String formatDate(String dateString) {
  if (dateString.isEmpty) return "-";
  final date = DateTime.parse(dateString);
  return DateFormat("dd MMM yyyy").format(date);
}

class Home extends StatefulWidget {
  final String username;
  const Home({super.key, required this.username});

  @override
  State<Home> createState() => _MovieListViewState();
}

class _MovieListViewState extends State<Home> {
  late MovieController controller;
  List<MovieList> movies = [];
  int currentPage = 1;
  bool isLoadingMore = false;
  bool isSearching = false;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = MovieController(tmdbService: TmdbService());
    _movie();
  }

  Future<void> _movie() async {
    final data = await controller.getMovies(page: currentPage);
    setState(() {
      movies = data;
    });
  }

  Future<void> _loadMore() async {
    if (isLoadingMore) return;
    setState(() => isLoadingMore = true);

    currentPage++;
    final data = await controller.getMovies(page: currentPage);

    setState(() {
      movies.addAll(data);
      isLoadingMore = false;
    });
  }

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      setState(() {
        isSearching = false;
      });
      await _movie();
      return;
    }

    setState(() => isSearching = true);
    try {
    final results = await controller.searchMovies(query);
    setState(() {
      movies = results;
    });
  } catch (e) {
    print("Error search: $e");
  }

    final results = await controller.searchMovies(query);
    setState(() => movies = results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 18, 18, 18),
        title: Text(
              "Halo, ${widget.username}",
              style: TextStyle(fontSize: 18, 
              fontWeight: FontWeight.bold, 
              color: Colors.white),
            ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(40), 
            child: TextField(
              controller: searchController,
              onChanged: searchMovies,
              decoration: InputDecoration(
                hintText: "Cari...",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                )
              ),
            )
            ),
          actions: [
            IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(
                  builder: (context) {
                    return LoginPage();
                  }
                  ),

                );
            },
            icon: Icon(Icons.logout, color: Colors.white),
          ),
          ],
          ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if(!isLoadingMore &&
          scrollInfo.metrics.pixels ==
          scrollInfo.metrics.maxScrollExtent) {
            _loadMore();
          }
          return false;
        },
        child: movies.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: EdgeInsets.all(15),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 0.65,
              ),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final m = movies[index];
                return MovieCard(
                  title: m.title,
                  posterPath: m.posterPath,
                  rating: m.rating,
                  release: m.releaseDate,
                  id: m.id,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Detail(id: m.id, movie: m, username: widget.username,),
                      ),
                    );
                  },
                );
              },
            ),
        ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final int id;
  final String title;
  final String posterPath;
  final double rating;
  final String release;
  final VoidCallback onTap;

  const MovieCard({
    super.key,
    required this.id,
    required this.title,
    required this.posterPath,
    required this.rating,
    required this.release,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 5,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              "https://image.tmdb.org/t/p/w500$posterPath",
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  height: 280,
                  color: Colors.grey.shade800,
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (context, error, StackTrace) => Container(
                height: 280,
                color: Colors.grey.shade700,
                child: const Icon(
                  Icons.broken_image,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              height: 120,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black87, Colors.transparent],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(1, 1),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 15),
                      SizedBox(width: 5),
                      Text(
                        rating.toStringAsFixed(1),
                        style: TextStyle(color: Colors.white),
                      ),
                      Spacer(),
                      Text(
                        formatDate(release),
                        style: TextStyle(color: Colors.white),
                        )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}