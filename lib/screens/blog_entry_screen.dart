import 'dart:io';
// 'dart:io' is used to handle file operations such as saving and displaying images.
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/blog.dart';
// Imports the Blog model to manage blog data.
import '../services/blog_service.dart';
// Imports BlogService to handle data storage and retrieval.

class BlogEntryScreen extends StatefulWidget {
  final Blog? blog;
  const BlogEntryScreen({super.key, this.blog});

  @override
  State<BlogEntryScreen> createState() => _BlogEntryScreenState();
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
      final directory = await getApplicationDocumentsDirectory();
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String newPath = '${directory.path}/$fileName';
      final File newImage = await File(pickedFile.path).copy(newPath);
      setState(() {
        _imagePath = newImage.path;
      });
    }
  }

  void _saveBlog() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title and content cannot be empty!")),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Title')),
            const SizedBox(height: 10),
            TextField(controller: _contentController, decoration: const InputDecoration(labelText: 'Content'), maxLines: 5),
            const SizedBox(height: 10),
            _imagePath != null ? Image.file(File(_imagePath!), height: 150) : Container(),
            Row(
              children: [
                ElevatedButton.icon(onPressed: () => _pickImage(ImageSource.gallery), icon: const Icon(Icons.image), label: const Text('Gallery')),
                ElevatedButton.icon(onPressed: () => _pickImage(ImageSource.camera), icon: const Icon(Icons.camera), label: const Text('Camera')),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _saveBlog, child: const Text('Save Blog')),
          ],
        ),
      ),
    );
  }
}
