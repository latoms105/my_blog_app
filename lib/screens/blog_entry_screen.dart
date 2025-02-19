import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../models/blog.dart';
import '../services/blog_service.dart';

class BlogEntryScreen extends StatefulWidget {
  final Blog? blog;
  BlogEntryScreen({this.blog});

  @override
  _BlogEntryScreenState createState() => _BlogEntryScreenState();
}

class _BlogEntryScreenState extends State<BlogEntryScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String? _imagePath;
  final BlogService _blogService = BlogService();
  final uuid = Uuid();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.blog != null) {
      _isEditing = true;
      _titleController.text = widget.blog!.title;
      _contentController.text = widget.blog!.content;
      _imagePath = widget.blog!.imagePath;
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  void _saveBlog() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Title and content cannot be empty!")),
      );
      return;
    }

    Blog newBlog = Blog(
      id: _isEditing ? widget.blog!.id : uuid.v4(),
      title: _titleController.text,
      date: DateTime.now().toIso8601String(),
      content: _contentController.text,
      imagePath: _imagePath,
    );

    if (_isEditing) {
      await _blogService.updateBlog(newBlog);
    } else {
      await _blogService.addBlog(newBlog);
    }

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Blog' : 'New Blog')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
            SizedBox(height: 10),
            _imagePath != null ? Image.file(File(_imagePath!), height: 150) : Container(),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: Icon(Icons.image),
                  label: Text('Gallery'),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: Icon(Icons.camera),
                  label: Text('Camera'),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveBlog,
              child: Text('Save Blog'),
            ),
          ],
        ),
      ),
    );
  }
}
