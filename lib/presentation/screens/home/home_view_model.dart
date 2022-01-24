import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:wallbay/presentation/controller/core/default_noitifer.dart';

final homeViewProvider = ChangeNotifierProvider((ref) => HomeViewModel());

class HomeViewModel extends DefaultChangeNotifier {
  int selectedIndex = 0;
  PageController controller = PageController();
  List<GButton> tabs = [];

  void updateIndex(int page) {
    selectedIndex = page;
    notifyListeners();
  }

  init() {
    const padding = EdgeInsets.symmetric(horizontal: 18, vertical: 5);
    const double gap = 10;

    tabs.add(GButton(
      gap: gap,
      iconActiveColor: Colors.purple,
      iconColor: Colors.black,
      textColor: Colors.purple,
      backgroundColor: Colors.purple.withOpacity(.2),
      iconSize: 24,
      padding: padding,
      icon: Icons.verified_user,
      text: "Editor's Choice",
    ));

    tabs.add(GButton(
      gap: gap,
      iconActiveColor: Colors.teal,
      iconColor: Colors.black,
      textColor: Colors.teal,
      backgroundColor: Colors.teal.withOpacity(.2),
      iconSize: 24,
      padding: padding,
      icon: Icons.category,
      text: 'Category',
    ));
  }
}
