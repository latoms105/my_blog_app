import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/blog.dart';

class BlogService {
  static const String _storageKey = "anime_blog_items";

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
      List<String> blogList = blogs.map((blog) => jsonEncode(blog.toJson())).toList();
      await prefs.setStringList(_storageKey, blogList);
    }
  }

  Future<void> deleteBlogs(List<String> blogIds) async {
    final prefs = await SharedPreferences.getInstance();
    List<Blog> blogs = await getBlogs();
    blogs.removeWhere((blog) => blogIds.contains(blog.id));
    List<String> blogList = blogs.map((blog) => jsonEncode(blog.toJson())).toList();
    await prefs.setStringList(_storageKey, blogList);
  }
}

