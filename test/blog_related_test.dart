import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_blog_app/Screens/blog_list_screen.dart'; // ✅ Correct import path

void main() {
  testWidgets('Blog List Screen should display a title', (WidgetTester tester) async {
    // Build the widget inside the test environment
    await tester.pumpWidget(
      MaterialApp( // ✅ Removed `const`
        home: BlogListScreen(),
      ),
    );

    // Verify if "Anime Blog" title appears
    expect(find.text('Anime Blog'), findsOneWidget);
  });

  testWidgets('Floating action button should be present', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp( // ✅ Removed `const`
        home: BlogListScreen(),
      ),
    );

    // Verify if the Floating Action Button is present
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
