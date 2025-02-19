import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/blog.dart';

class BlogService {
  static const String _storageKey = "blog_items";

  Future<void> addBlog(Blog blog) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> blogList = prefs.getStringList(_storageKey) ?? [];
    blogList.add(jsonEncode(blog.toJson()));
    await prefs.setStringList(_storageKey, blogList);
  }

  Future<List<Blog>> getBlogs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? blogList = prefs.getStringList(_storageKey);
    if (blogList == null) return [];
    return blogList.map((item) => Blog.fromJson(jsonDecode(item))).toList();
  }

  Future<void> updateBlog(Blog updatedBlog) async {
    final prefs = await SharedPreferences.getInstance();
    List<Blog> blogs = await getBlogs();
    int index = blogs.indexWhere((blog) => blog.id == updatedBlog.id);
    if (index != -1) {
      blogs[index] = updatedBlog;
      List<String> updatedList = blogs.map((blog) => jsonEncode(blog.toJson())).toList();
      await prefs.setStringList(_storageKey, updatedList);
    }
  }

  Future<void> deleteBlog(String blogId) async {
    final prefs = await SharedPreferences.getInstance();
    List<Blog> blogs = await getBlogs();
    blogs.removeWhere((blog) => blog.id == blogId);
    List<String> updatedList = blogs.map((blog) => jsonEncode(blog.toJson())).toList();
    await prefs.setStringList(_storageKey, updatedList);
  }

  Future<void> deleteMultipleBlogs(List<String> blogIds) async {
    final prefs = await SharedPreferences.getInstance();
    List<Blog> blogs = await getBlogs();
    blogs.removeWhere((blog) => blogIds.contains(blog.id));
    List<String> updatedList = blogs.map((blog) => jsonEncode(blog.toJson())).toList();
    await prefs.setStringList(_storageKey, updatedList);
  }

  Future<void> printFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/blog_data.json';
    print("✅ Blog data is stored at: $filePath");
  }
}
