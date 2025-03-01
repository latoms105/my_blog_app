import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screens/blog_list_screen.dart';
import 'services/blog_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _requestPermissions();
  BlogService().printFilePath();
  runApp(MyApp());
}

Future<void> _requestPermissions() async {
  await Permission.camera.request();
  await Permission.photos.request();
  await Permission.storage.request();
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
