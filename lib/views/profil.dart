import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_akhir/views/login.dart';
import 'package:hive/hive.dart';

class Profil extends StatefulWidget {
  final String user;
  const Profil({super.key, required this.user});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  late String _nama;
  final String _nim = "124230070";
  final String _kelas = "Pemrograman Aplikasi Mobile SI - B";

  @override
  void initState() {
    super.initState();
    _nama = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () async {
              var sessionBox = Hive.box('session');
              await sessionBox.clear();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const LoginPage();
                    },
                  ),
                );
              }
            },
            icon: const FaIcon(
              FontAwesomeIcons.rightFromBracket,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 15, bottom: 15),
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage("assets/img/duki.jpg"),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _infoRow("Nama", _nama),
              _infoRow("NIM", _nim),
              _infoRow("Kelas", _kelas),
              const SizedBox(height: 10),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.white38, width: 1),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color.fromARGB(255, 37, 216, 101))
                ),
                child: Column(
                  children: [
                    Text(
                      "Kesan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Sangat mantapp, sampai membuat susah tidur",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color.fromARGB(255, 37, 216, 101))
                ),
                child: Column(
                  children: [
                    Text(
                      "Pesan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Semoga kedepannya, bisa tidur lebih nyenyak",
                      style: TextStyle(color: Colors.white),
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

  Widget _infoRow(
    String label,
    String value,
    ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      width: double.infinity,
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const Text(":", style: TextStyle(color: Colors.white)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
