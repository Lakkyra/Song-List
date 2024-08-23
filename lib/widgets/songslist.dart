import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/data/categories.dart';

import 'package:test_app/models/genre.dart';
import 'package:test_app/widgets/new_item.dart';

class SongsList extends StatefulWidget {
  const SongsList({super.key});

  @override
  State<SongsList> createState() => _SongsListState();
}

class _SongsListState extends State<SongsList> {
  List<SongItem> _songItems = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
        'flutter-proj-12582-default-rtdb.firebaseio.com', 'songs_-ist.json');
    try {
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        setState(() {
          _error = 'Failed to fetch data. Please try again later.';
        });
      }

      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final Map<String, dynamic> listData = json.decode(response.body);
      final List<SongItem> loadedItems = [];
      for (final item in listData.entries) {
        final category = categories.entries
            .firstWhere(
                (catItem) => catItem.value.title == item.value['category'])
            .value;
        loadedItems.add(
          SongItem(
            id: item.key,
            name: item.value['name'],
            artist: item.value['artist'],
            category: category,
          ),
        );
      }
      setState(() {
        _songItems = loadedItems;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = 'Something went wrong! Please try again later.';
      });
    }
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<SongItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );

    if (newItem == null) {
      return;
    }

    setState(() {
      _songItems.add(newItem);
    });
  }

  void _removeItem(SongItem item) async {
    final index = _songItems.indexOf(item);
    setState(() {
      _songItems.remove(item);
    });

    final url = Uri.https('flutter-proj-12582-default-rtdb.firebaseio.com',
        'songs_-ist/${item.id}.json');
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      // Optional: Show error message
      setState(() {
        _songItems.insert(index, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('No items added yet.'));

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }

    if (_songItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _songItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) {
            _removeItem(_songItems[index]);
          },
          key: ValueKey(_songItems[index].id),
          child: ListTile(
            title: Text(_songItems[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: _songItems[index].category.color,
            ),
            trailing: Text(
              _songItems[index].artist,
            ),
          ),
        ),
      );
    }
    if (_error != null) {
      content = Center(child: Text(_error!));
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Songs'),
          actions: [
            IconButton(
              onPressed: _addItem,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: content);
  }
}
