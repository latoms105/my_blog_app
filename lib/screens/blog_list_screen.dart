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
  List<Blog> _blogs = [];
  List<Blog> _filteredBlogs = [];
  Set<String> _selectedBlogs = {};
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBlogs();
    _searchController.addListener(_filterBlogs);
  }

  Future<void> _loadBlogs() async {
    List<Blog> blogs = await _blogService.getBlogs();
    setState(() {
      _blogs = blogs;
      _filteredBlogs = blogs;
    });
  }

  void _filterBlogs() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredBlogs = _blogs
          .where((blog) =>
      blog.title.toLowerCase().contains(query) ||
          blog.content.toLowerCase().contains(query))
          .toList();
    });
  }

  void _deleteBlog(String blogId) async {
    await _blogService.deleteBlog(blogId);
    _loadBlogs();
  }

  void _deleteSelectedBlogs() async {
    await _blogService.deleteMultipleBlogs(_selectedBlogs.toList());
    setState(() {
      _selectedBlogs.clear();
    });
    _loadBlogs();
  }

  void _navigateToEntryScreen({Blog? blog}) async {
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlogEntryScreen(blog: blog),
      ),
    );
    if (result == true) {
      _loadBlogs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Blog'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _selectedBlogs.isNotEmpty ? _deleteSelectedBlogs : null,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Blogs...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredBlogs.length,
              itemBuilder: (context, index) {
                Blog blog = _filteredBlogs[index];
                bool isSelected = _selectedBlogs.contains(blog.id);

                return ListTile(
                  title: Text(blog.title),
                  subtitle: Text(blog.date),
                  leading: blog.imagePath != null
                      ? Image.file(File(blog.imagePath!), width: 50)
                      : Icon(Icons.article),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: isSelected ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isSelected) {
                          _selectedBlogs.remove(blog.id);
                        } else {
                          _selectedBlogs.add(blog.id);
                        }
                      });
                    },
                  ),
                  onTap: () {
                    _navigateToEntryScreen(blog: blog);
                  },
                  onLongPress: () {
                    setState(() {
                      if (isSelected) {
                        _selectedBlogs.remove(blog.id);
                      } else {
                        _selectedBlogs.add(blog.id);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToEntryScreen(),
        child: Icon(Icons.add),
      ),
    );
  }
}
