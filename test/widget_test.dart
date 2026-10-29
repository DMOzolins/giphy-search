import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giphy_search/giphy_api.dart';
import 'package:giphy_search/search_page.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'test_data.dart';

void main() {
  testWidgets('shows a hint before searching', (tester) async {
    final client = MockClient((request) async {
      return http.Response('', 500);
    });

    await tester.pumpWidget(
      MaterialApp(home: SearchPage(api: GiphyApi(client))),
    );

    expect(find.text('Type something to search for GIFs'), findsOneWidget);
  });

  testWidgets('searches after typing and shows the GIFs', (tester) async {
    final client = MockClient((request) async {
      return http.Response(
        jsonEncode({
          'data': [gifJson, gifJson, gifJson],
        }),
        200,
      );
    });

    await tester.pumpWidget(
      MaterialApp(home: SearchPage(api: GiphyApi(client))),
    );
    await tester.enterText(find.byType(TextField), 'cat');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump();

    expect(find.byType(GridView), findsOneWidget);
    expect(find.byType(Image), findsNWidgets(3));
  });

  testWidgets('loads more GIFs when scrolling down', (tester) async {
    final offsets = <String>[];
    final client = MockClient((request) async {
      offsets.add(request.url.queryParameters['offset']!);
      return http.Response(
        jsonEncode({'data': List.generate(25, (index) => gifJson)}),
        200,
      );
    });

    await tester.pumpWidget(
      MaterialApp(home: SearchPage(api: GiphyApi(client))),
    );
    await tester.enterText(find.byType(TextField), 'cat');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump();
    await tester.drag(find.byType(GridView), const Offset(0, -3000));
    await tester.pump();
    await tester.pump();

    expect(offsets, ['0', '25']);
  });

  testWidgets('tapping a GIF opens the detail page', (tester) async {
    final client = MockClient((request) async {
      return http.Response(
        jsonEncode({
          'data': [gifJson],
        }),
        200,
      );
    });

    await tester.pumpWidget(
      MaterialApp(home: SearchPage(api: GiphyApi(client))),
    );
    await tester.enterText(find.byType(TextField), 'cat');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump();
    await tester.tap(find.byType(Image));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Funny cat'), findsOneWidget);
    expect(find.text('Author: catlover'), findsOneWidget);
  });

  testWidgets('shows an error when there is no internet', (tester) async {
    final client = MockClient((request) async {
      throw const SocketException('No internet');
    });

    await tester.pumpWidget(
      MaterialApp(home: SearchPage(api: GiphyApi(client))),
    );
    await tester.enterText(find.byType(TextField), 'cat');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump();

    expect(
      find.text('No internet connection. Check your connection and try again.'),
      findsOneWidget,
    );
    expect(find.text('Try again'), findsOneWidget);
  });
}
