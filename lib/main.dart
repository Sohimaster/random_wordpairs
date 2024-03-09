import 'package:flutter/material.dart';
import 'random_words.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(context) {
    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.purple[900]),
        home: const RandomWords());
  }
}
