import 'dart:convert';

class Blog {
  final String id;
  final String title;
  final String date;
  final String content;
  final String? imagePath;

  Blog({
    required this.id,
    required this.title,
    required this.date,
    required this.content,
    this.imagePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'content': content,
      'imagePath': imagePath,
    };
  }

  static Blog fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'],
      title: json['title'],
      date: json['date'],
      content: json['content'],
      imagePath: json['imagePath'],
    );
  }
}
