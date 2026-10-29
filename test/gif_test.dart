import 'package:flutter_test/flutter_test.dart';
import 'package:giphy_search/gif.dart';

import 'test_data.dart';

void main() {
  test('Gif.fromJson reads the data from Giphy', () {
    final gif = Gif.fromJson(gifJson);

    expect(gif.id, 'abc');
    expect(gif.title, 'Funny cat');
    expect(gif.username, 'catlover');
    expect(gif.rating, 'g');
    expect(gif.smallUrl, 'https://media.giphy.com/small.gif');
    expect(gif.bigUrl, 'https://media.giphy.com/big.gif');
    expect(gif.width, 480);
    expect(gif.height, 270);
  });
}
