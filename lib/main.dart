import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'giphy_api.dart';
import 'search_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter gif app',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: SearchPage(api: GiphyApi(http.Client())),
    );
  }
}
