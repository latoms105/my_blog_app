import 'dart:convert';

class Blog {
  String id;
  String title;
  String date;
  String content;
  String? imagePath;

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
