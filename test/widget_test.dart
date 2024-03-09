import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:random_wordpairs/random_words.dart';

void main() {
  testWidgets('List builds with generated word pairs', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: RandomWords()));

    // Verify that list items (word pairs) are created.
    expect(find.byType(ListTile), findsWidgets);
  });

  testWidgets('Tapping on a list tile toggles its saved state', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: RandomWords()));

    // Tap the first ListTile to add the word pair to saved list.
    await tester.tap(find.byType(ListTile).first);
    await tester.pumpAndSettle();

    // Check if the icon changes to indicate saved state.
    expect(find.byIcon(Icons.favorite), findsWidgets);

    // Tap the same ListTile to remove it from saved list.
    await tester.tap(find.byType(ListTile).first);
    await tester.pumpAndSettle();

    // Verify the icon changes back.
    expect(find.byIcon(Icons.favorite_border), findsWidgets);
  });

  testWidgets('Navigating to saved word pairs page shows saved items', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: RandomWords()));

    // Tap the first ListTile to add the word pair to saved list.
    await tester.tap(find.byType(ListTile).first);
    await tester.pumpAndSettle();

    // Tap the "Saved" IconButton to navigate to saved word pairs.
    await tester.tap(find.byIcon(Icons.list));
    await tester.pumpAndSettle();

    // Verify that the saved word pairs page is shown with the expected item.
    expect(find.byType(ListTile), findsWidgets);
    expect(find.byIcon(Icons.delete), findsWidgets); // Indicates we're on the saved page.
  });
}