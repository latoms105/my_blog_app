import 'package:flutter/material.dart';
import 'screens/blog_list_screen.dart';
import 'services/blog_service.dart';

void main() {
  BlogService().printFilePath();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlogListScreen(),
    );
  }
}
