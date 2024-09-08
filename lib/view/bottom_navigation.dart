import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:translator/view/bottomnavigationbar_page/favourite_screen.dart';
import 'package:translator/view/bottomnavigationbar_page/history_screen.dart';
import 'package:translator/view/bottomnavigationbar_page/translator_screen.dart';

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  RxInt _currentIndex = 0.obs;

  final _pages = [
    TranslatorScreen(),
    FavouritePage(),
    HistoryPage(),
  ];
  //For Exit Dialouge start
  Future _exitDialoge(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "আপনি কি অ্যাপ থেকে বের হতে চান ?",
              style: TextStyle(
                color: Colors.indigo.shade900,
              ),
            ),
            content: Row(
              children: [
                TextButton(
                    onPressed: () => Navigator.pop(context), child: Text("না")),
                TextButton(
                    onPressed: () => SystemNavigator.pop(),
                    child: Text("হ্যাঁ")),
              ],
            ),
          );
        });
  }

  //For Exit Dialouge End

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          _exitDialoge(context);
          return Future.value(false);
        },
        child: Scaffold(
          backgroundColor: Colors.indigo.shade900,
          body: _pages[_currentIndex.value],
          bottomNavigationBar: FloatingNavbar(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 0),
            margin: EdgeInsets.all(0),
            fontSize: 13.sp,
            iconSize: 22.sp,
            backgroundColor: Colors.indigo.shade900,
            currentIndex: _currentIndex.value,
            onTap: (value) {
              _currentIndex.value = value;
              setState(() {});
            },
            items: [
              FloatingNavbarItem(icon: Icons.home, title: 'Home'),
              FloatingNavbarItem(icon: Icons.favorite, title: 'Favourite'),
              FloatingNavbarItem(icon: Icons.history, title: 'History'),
            ],
          ),
        ));
  }
}
