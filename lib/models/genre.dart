import 'package:test_app/models/category.dart';

class SongItem {
  const SongItem(
      {required this.id,
      required this.name,
      required this.artist,
      required this.category});

  final String id;
  final String name;
  final String artist;
  final Category category;
}
