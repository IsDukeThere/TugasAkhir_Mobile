import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_akhir/model/movie_list.dart';
import 'package:project_akhir/services/notifikasi.dart';
import 'package:project_akhir/views/login.dart';
import 'package:project_akhir/widgets/navbar.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await requestNotificationPermission();

  await Hive.initFlutter();
  Hive.registerAdapter(MovieListAdapter());
  await Hive.openBox('users');
  var sessionBox = await Hive.openBox('session');
  await Hive.openBox<MovieList>('watchlist');

  runApp(MyApp(sessionBox: sessionBox));
}

class MyApp extends StatelessWidget {
  final Box sessionBox;
  const MyApp({super.key, required this.sessionBox});

  @override
  Widget build(BuildContext context) {
    String? activeUser = sessionBox.get('activeUser');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
        )
      ),
      home: activeUser != null ? Navbar(name: activeUser) : const LoginPage(),
    );
  }
}