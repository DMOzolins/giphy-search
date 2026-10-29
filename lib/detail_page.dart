import 'package:flutter/material.dart';

import 'gif.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.gif});

  final Gif gif;

  @override
  Widget build(BuildContext context) {
    final image = Image.network(
      gif.bigUrl,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return const Center(child: Text('Image failed to load'));
      },
    );

    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          gif.title.isEmpty ? 'No title' : gif.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text('Author: ${gif.username.isEmpty ? 'unknown' : gif.username}'),
        Text('Rating: ${gif.rating}'),
        Text('Size: ${gif.width} x ${gif.height}'),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: const Text('GIF')),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [image, const SizedBox(height: 16), info],
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: image),
                    const SizedBox(width: 16),
                    Expanded(child: SingleChildScrollView(child: info)),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
