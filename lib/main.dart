import 'package:flutter/material.dart';
// 'permission_handler' is used to request permissions for camera, photos, and storage access.
import 'package:permission_handler/permission_handler.dart';
import 'screens/blog_list_screen.dart';
// Sets the BlogListScreen as the home screen of the app.
import 'services/blog_service.dart';
// Initializes the BlogService to manage the blog data lifecycle.

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
  const MyApp({super.key});
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
