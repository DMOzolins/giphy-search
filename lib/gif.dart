class Gif {
  final String id;
  final String title;
  final String username;
  final String rating;
  final String smallUrl;
  final String bigUrl;
  final int width;
  final int height;

  const Gif({
    required this.id,
    required this.title,
    required this.username,
    required this.rating,
    required this.smallUrl,
    required this.bigUrl,
    required this.width,
    required this.height,
  });

  factory Gif.fromJson(Map<String, dynamic> json) {
    return Gif(
      id: json['id'],
      title: json['title'] ?? '',
      username: json['username'] ?? '',
      rating: json['rating'] ?? '',
      smallUrl: json['images']['fixed_width']['url'],
      bigUrl: json['images']['original']['url'],
      width: int.parse(json['images']['original']['width']),
      height: int.parse(json['images']['original']['height']),
    );
  }
}
