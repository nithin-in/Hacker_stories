import 'package:flutter/material.dart';
import 'package:hacker_stories/screen/screen.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "Hacker Stories", home: TopArticleList());
  }
}
