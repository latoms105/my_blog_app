import 'package:flutter/material.dart';
import 'screens/blog_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anime Blog',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlogListScreen(),
    );
  }
}
