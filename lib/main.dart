import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _searchcontroller = TextEditingController();
  String title = "";
  String year = "";
  String actors = "";
  var poster = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Searcher',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Movie Searcher'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                TextField(
                    controller: _searchcontroller,
                    decoration: InputDecoration(
                        hintText: "Search Movie Name here",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)))),
                MaterialButton(
                    color: Colors.greenAccent,
                    onPressed: () {
                      _loadMovie(_searchcontroller.text);
                    },
                    child: const Text("Press Me")),
                const SizedBox(height: 10),
                Card(
                  margin: const EdgeInsets.all(16),
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    child: Column(children: [
                      Image.network(
                        poster,
                        height: 250,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                              height: 250,
                              width: 250,
                              fit: BoxFit.cover,
                              'assets/images/movie.jpg');
                        },
                      ),
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(year),
                      Text(actors)
                    ]),
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loadMovie(String search) async {
    var url = Uri.parse('https://www.omdbapi.com/?t=$search&apikey=12d5b34');
    var response = await http.get(url);
    var rescode = response.statusCode;
    if (rescode == 200) {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
      title = parsedJson['Title'];
      year = parsedJson['Year'];
      actors = parsedJson['Actors'];
      poster = parsedJson['Poster'];
      setState(() {});
      print(response.body);
    } else {
      print("Failed");
    }
  }
}
