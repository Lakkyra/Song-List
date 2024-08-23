import 'package:flutter/material.dart';

enum Categories { Rock, Pop, Rap, EDM, Indie, Reggae, RNB }

class Category {
  const Category(this.title, this.color);

  final String title;
  final Color color;
}
