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
    image: AssetImage("assets/image/abstract.jpg"),
    name: "Abstract",
  ),
  Category(
    image: AssetImage("assets/image/car.jpg"),
    name: "Cars",
  ),
  Category(
    image: AssetImage("assets/image/city.jpg"),
    name: "City",
  ),
  Category(
    image: AssetImage("assets/image/minimalist.jpg"),
    name: "Minimalist",
  ),
  Category(
    image: AssetImage("assets/image/nature.jpg"),
    name: "Nature",
  ),
  Category(
    image: AssetImage("assets/image/space.jpg"),
    name: "Space",
  ),
  Category(
    image: AssetImage("assets/image/sport.jpg"),
    name: "Sport",
  ),
];
