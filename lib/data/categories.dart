import 'package:flutter/material.dart';
import 'package:test_app/models/category.dart';

const categories = {
  Categories.Rock: Category(
    'Rock',
    Color.fromARGB(255, 0, 255, 17),
  ),
  Categories.Pop: Category(
    'Pop',
    Color.fromARGB(255, 228, 248, 4),
  ),
  Categories.EDM: Category(
    'EDM',
    Color.fromARGB(255, 255, 102, 0),
  ),
  Categories.Indie: Category(
    'Indie',
    Color.fromARGB(255, 6, 221, 210),
  ),
  Categories.Reggae: Category(
    'Reggae',
    Color.fromARGB(255, 0, 60, 255),
  ),
  Categories.RNB: Category(
    'RNB',
    Color.fromARGB(255, 201, 10, 249),
  ),
};
