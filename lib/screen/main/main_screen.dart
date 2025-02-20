import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/provider/main/index_nav_provider.dart';
import 'package:restaurant/screen/favorite/favorite_screen.dart';
import 'package:restaurant/screen/home/home_screen.dart';
import 'package:restaurant/screen/setting/setting_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<IndexNavProvider>(builder: (context, value, child){
        return switch(value.indexBottomNavBar){
          1 => const FavoriteScreen(),
          2 => const SettingScreen(),
          _ => const HomeScreen(),
        };
      }),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: context.watch<IndexNavProvider>().indexBottomNavBar,
        onTap: (index){
          context.read<IndexNavProvider>().setIndexBottomNavBar = index;
        },
        items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home), label: "Home", tooltip: "Home"),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite), label: "Favorite", tooltip: "Favorite"),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings), label: "Setting", tooltip: "setting"),
      ]),
    );
  }
}
