import 'dart:io';
// 'dart:io' is used for file operations in displaying blog images.
import 'package:flutter/material.dart';
import '../models/blog.dart';
// Imports the Blog model to display the list of blogs.
import '../services/blog_service.dart';
// Imports BlogService to fetch and manage stored blogs.
import 'blog_entry_screen.dart';
// Imports BlogEntryScreen to navigate to the blog creation and editing screen.

class BlogListScreen extends StatefulWidget {
  const BlogListScreen({super.key});

  @override
  State<BlogListScreen> createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  final BlogService _blogService = BlogService();
  List<Blog> _blogs = [];
  List<Blog> _filteredBlogs = [];
  final List<Blog> _selectedBlogs = [];
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

  void _deleteSelectedBlogs() async {
    await _blogService.deleteMultipleBlogs(_selectedBlogs.map((blog) => blog.id).toList());
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
        title: const Text('My Blog'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _selectedBlogs.isNotEmpty ? _deleteSelectedBlogs : null,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
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
                bool isSelected = _selectedBlogs.contains(blog);

                return ListTile(
                  title: Text(blog.title),
                  subtitle: Text(blog.date),
                  leading: blog.imagePath != null
                      ? Image.file(File(blog.imagePath!), width: 50)
                      : const Icon(Icons.article),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: isSelected ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isSelected) {
                          _selectedBlogs.remove(blog);
                        } else {
                          _selectedBlogs.add(blog);
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
                        _selectedBlogs.remove(blog);
                      } else {
                        _selectedBlogs.add(blog);
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
