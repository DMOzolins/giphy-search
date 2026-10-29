import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:giphy_search/giphy_api.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'test_data.dart';

void main() {
  test('searchGifs returns a list of GIFs', () async {
    final client = MockClient((request) async {
      return http.Response(
        jsonEncode({
          'data': [gifJson, gifJson],
        }),
        200,
      );
    });

    final gifs = await GiphyApi(client).searchGifs('cat', 0);

    expect(gifs.length, 2);
    expect(gifs[0].title, 'Funny cat');
  });

  test('searchGifs sends the search text and offset', () async {
    Uri? url;
    final client = MockClient((request) async {
      url = request.url;
      return http.Response(jsonEncode({'data': []}), 200);
    });

    await GiphyApi(client).searchGifs('cat', 25);

    expect(url!.path, '/v1/gifs/search');
    expect(url!.queryParameters['q'], 'cat');
    expect(url!.queryParameters['offset'], '25');
    expect(url!.queryParameters['limit'], '25');
  });

  test('searchGifs throws an exception when the server has an error', () {
    final client = MockClient((request) async {
      return http.Response('', 500);
    });

    expect(GiphyApi(client).searchGifs('cat', 0), throwsException);
  });
}
