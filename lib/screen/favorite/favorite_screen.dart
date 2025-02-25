import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/provider/detail/favorite_list_provider.dart';
import 'package:restaurant/screen/home/restaurant_card_widget.dart';
import 'package:restaurant/static/navigation_route.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late Future<void> _favoriteFuture;

  @override
  void initState() {
    super.initState();
    _favoriteFuture = _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    await Provider.of<FavoriteListProvider>(context, listen: false)
        .loadAllFavoriteValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite List"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _favoriteFuture = _loadFavorites(); 
              });
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _favoriteFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Failed to load data"));
          }

          return Consumer<FavoriteListProvider>(
            builder: (context, value, child) {
              final favoriteList = value.favoriteList;

              if (favoriteList.isEmpty) {
                return Center(child: Text("No Favorite Restaurant"));
              }

              return ListView.builder(
                itemCount: favoriteList.length,
                itemBuilder: (context, index) {
                  final restaurant = favoriteList[index];

                  return RestaurantCard(
                    key: ValueKey(restaurant.id), 
                    restaurant: restaurant,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        NavigationRoute.detailRoute.name,
                        arguments: restaurant.id,
                      ).then((_) {
                        setState(() {
                          _favoriteFuture = _loadFavorites(); 
                        });
                      });
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
