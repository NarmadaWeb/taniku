import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:taniku/main.dart';
import 'package:taniku/providers/app_provider.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppProvider()),
        ],
        child: const MyApp(),
      ),
    );

    // Verify that Welcome Screen is shown
    expect(find.text('TANIKU'), findsOneWidget);
    expect(find.text('Mulai'), findsOneWidget);
  });
}
