import 'package:flutter/material.dart';

class Category {
  String name;
  AssetImage image;

  Category({
    @required this.name,
    @required this.image,
  });
}

List<Category> categoryList = [
  Category(
    image: AssetImage("image/abstract.jpg"),
    name: "Abstract",
  ),
  Category(
    image: AssetImage("image/car.jpg"),
    name: "Cars",
  ),
  Category(
    image: AssetImage("image/city.jpg"),
    name: "City",
  ),
  Category(
    image: AssetImage("image/minimalist.jpg"),
    name: "Minimalist",
  ),
  Category(
    image: AssetImage("image/nature.jpg"),
    name: "Nature",
  ),
  Category(
    image: AssetImage("image/space.jpg"),
    name: "Space",
  ),
  Category(
    image: AssetImage("image/sport.jpg"),
    name: "Sport",
  ),
];
