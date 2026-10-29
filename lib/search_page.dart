import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'detail_page.dart';
import 'gif.dart';
import 'giphy_api.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.api});

  final GiphyApi api;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final scrollController = ScrollController();
  Timer? timer;
  String searchText = '';
  int searchNumber = 0;
  List<Gif> gifs = [];
  bool isLoading = false;
  bool hasMore = true;
  String? error;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(onScroll);
  }

  @override
  void dispose() {
    timer?.cancel();
    scrollController.dispose();
    super.dispose();
  }

  void onTextChanged(String text) {
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 500), () {
      if (text.trim() == searchText) {
        return;
      }
      setState(() {
        searchText = text.trim();
        searchNumber++;
        gifs = [];
        isLoading = false;
        hasMore = true;
        error = null;
      });
      loadGifs();
    });
  }

  void onScroll() {
    final position = scrollController.position;
    if (error == null && position.pixels >= position.maxScrollExtent * 0.9) {
      loadGifs();
    }
  }

  Future<void> loadGifs() async {
    if (searchText.isEmpty || isLoading || !hasMore) {
      return;
    }

    final number = searchNumber;
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final newGifs = await widget.api.searchGifs(searchText, gifs.length);
      if (!mounted || number != searchNumber) {
        return;
      }
      setState(() {
        gifs.addAll(newGifs);
        hasMore = newGifs.length == 25;
        isLoading = false;
      });
    } on SocketException {
      if (!mounted || number != searchNumber) {
        return;
      }
      setState(() {
        error = 'No internet connection. Check your connection and try again.';
        isLoading = false;
      });
    } catch (e) {
      if (!mounted || number != searchNumber) {
        return;
      }
      setState(() {
        error = e.toString().replaceFirst('Exception: ', '');
        isLoading = false;
      });
    }
  }

  void openGif(Gif gif) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => DetailPage(gif: gif)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GIF Search')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                onChanged: onTextChanged,
                decoration: const InputDecoration(
                  hintText: 'Search GIFs',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(child: buildResults()),
            if (isLoading && gifs.isNotEmpty)
              const Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(),
              ),
            if (error != null && gifs.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(child: Text(error!)),
                    TextButton(onPressed: loadGifs, child: const Text('Retry')),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildResults() {
    if (searchText.isEmpty) {
      return const Center(child: Text('Type something to search for GIFs'));
    }

    if (gifs.isEmpty && isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (gifs.isEmpty && error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(error!, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: loadGifs, child: const Text('Try again')),
          ],
        ),
      );
    }

    if (gifs.isEmpty) {
      return const Center(child: Text('No GIFs found'));
    }

    return OrientationBuilder(
      builder: (context, orientation) {
        return GridView.builder(
          controller: scrollController,
          padding: const EdgeInsets.all(4),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: orientation == Orientation.portrait ? 3 : 5,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: gifs.length,
          itemBuilder: (context, index) {
            final gif = gifs[index];
            return GestureDetector(
              onTap: () => openGif(gif),
              child: Image.network(
                gif.smallUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image);
                },
              ),
            );
          },
        );
      },
    );
  }
}
