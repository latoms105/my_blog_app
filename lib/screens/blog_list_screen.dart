import 'dart:io';
import 'package:flutter/material.dart';
import '../models/blog.dart';
import '../services/blog_service.dart';
import 'blog_entry_screen.dart';

class BlogListScreen extends StatefulWidget {
  @override
  _BlogListScreenState createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  final BlogService _blogService = BlogService();
  List<Blog> blogs = [];
  List<String> selectedBlogs = [];

  @override
  void initState() {
    super.initState();
    _loadBlogs();
  }

  void _loadBlogs() async {
    List<Blog> loadedBlogs = await _blogService.getBlogs();
    setState(() {
      blogs = loadedBlogs;
    });
  }

  void _deleteSelectedBlogs() async {
    await _blogService.deleteBlogs(selectedBlogs);
    setState(() {
      blogs.removeWhere((blog) => selectedBlogs.contains(blog.id));
      selectedBlogs.clear();
    });
  }

  void _navigateToEntryScreen({Blog? blog}) async {
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BlogEntryScreen(blog: blog)),
    );
    if (result == true) {
      _loadBlogs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Anime Blog"),
        actions: selectedBlogs.isNotEmpty
            ? [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteSelectedBlogs,
          )
        ]
            : [],
      ),
      body: blogs.isEmpty
          ? Center(child: Text("No blogs available."))
          : ListView.builder(
        itemCount: blogs.length,
        itemBuilder: (context, index) {
          Blog blog = blogs[index];
          bool isSelected = selectedBlogs.contains(blog.id);
          return Card(
            color: isSelected ? Colors.grey[300] : null,
            child: ListTile(
              leading: blog.imagePath != null
                  ? Image.file(File(blog.imagePath!), width: 50, height: 50, fit: BoxFit.cover)
                  : Icon(Icons.image),
              title: Text(blog.title),
              subtitle: Text(blog.content),
              onTap: () => _navigateToEntryScreen(blog: blog),
              onLongPress: () {
                setState(() {
                  if (isSelected) {
                    selectedBlogs.remove(blog.id);
                  } else {
                    selectedBlogs.add(blog.id);
                  }
                });
              },
              trailing: selectedBlogs.isEmpty
                  ? IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteSelectedBlogs(),
              )
                  : null,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToEntryScreen(),
        child: Icon(Icons.add),
      ),
    );
  }
}
