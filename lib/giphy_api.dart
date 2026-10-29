import 'dart:convert';

import 'package:http/http.dart' as http;

import 'gif.dart';

const apiKey = String.fromEnvironment('GIPHY_API_KEY');

class GiphyApi {
  final http.Client client;

  GiphyApi(this.client);

  Future<List<Gif>> searchGifs(String text, int offset) async {
    final url = Uri.https('api.giphy.com', '/v1/gifs/search', {
      'api_key': apiKey,
      'q': text,
      'limit': '25',
      'offset': offset.toString(),
    });

    final response = await client.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<Gif> gifs = [];
      for (final item in json['data']) {
        gifs.add(Gif.fromJson(item));
      }
      return gifs;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception('Wrong or missing Giphy API key');
    } else if (response.statusCode == 429) {
      throw Exception('Too many requests. Wait a bit and try again');
    } else {
      throw Exception('Failed to load GIFs');
    }
  }
}
