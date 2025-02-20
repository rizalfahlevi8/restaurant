import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/data/model/restaurant.dart';
import 'package:restaurant/provider/detail/favorite_icon_provider.dart';
import 'package:restaurant/provider/detail/favorite_list_provider.dart';

class FavoriteIconWidget extends StatefulWidget {
  final Restaurant restaurant;
  const FavoriteIconWidget({super.key, required this.restaurant});

  @override
  State<FavoriteIconWidget> createState() => _FavoriteIconWidgetState();
}

class _FavoriteIconWidgetState extends State<FavoriteIconWidget> {
  @override
  void initState() {
    final favoriteListProvider = context.read<FavoriteListProvider>();
    final favoriteIconProvider = context.read<FavoriteIconProvider>();

    Future.microtask(() async {
      final restaurantInList = await favoriteListProvider
          .checkItemFavorite(widget.restaurant.id);
      favoriteIconProvider.isFavorite = restaurantInList;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          final favoriteListProvider = context.read<FavoriteListProvider>();
          final favoriteIconProvider = context.read<FavoriteIconProvider>();
          final isFavorite = favoriteIconProvider.isFavorite;

          if (!isFavorite) {
            favoriteListProvider.addFavorite(widget.restaurant);
          } else {
            favoriteListProvider.removeFavorite(widget.restaurant.id);
          }
          favoriteIconProvider.isFavorite = !isFavorite;
        },
        icon: Icon(
          context.watch<FavoriteIconProvider>().isFavorite
              ? Icons.favorite
              : Icons.favorite_outline,
        ));
  }
}
