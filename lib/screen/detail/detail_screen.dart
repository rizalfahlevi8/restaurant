import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/provider/detail/favorite_icon_provider.dart';
import 'package:restaurant/provider/detail/restaurant_detail_provider.dart';
import 'package:restaurant/screen/detail/body_of_detail_screen.dart';
import 'package:restaurant/screen/detail/favorite_icon_widget.dart';
import 'package:restaurant/static/restaurant_detail_result_state.dart';

class DetailScreen extends StatefulWidget {
  final String restaurantId;
  const DetailScreen({super.key, required this.restaurantId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask((){
      context.read<RestaurantDetailProvider>().fetchRestaurantDetail(widget.restaurantId);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurant Detail"),
        actions: [
         ChangeNotifierProvider(
           create: (context) => FavoriteIconProvider(),
           child: Consumer<RestaurantDetailProvider>(builder: (context, value, child){
            return switch(value.resultState){
              RestaurantDetailLoadedState(data: var restaurant) => FavoriteIconWidget(restaurant: restaurant),
              _ => const SizedBox(),
            };
           }),
         ),
       ],
      ),
      body: Consumer<RestaurantDetailProvider>(builder: (context, value, child){
        return switch (value.resultState){
          RestaurantDetailLoadingState() => Center(child: CircularProgressIndicator(),),
          RestaurantDetailLoadedState(data: var restaurant) => BodyOfDetailScreen(restaurant: restaurant),
          RestaurantDetailErrorState(error: var message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 50,
                    color: Colors.redAccent,
                  ),
                  SizedBox(height: 20),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      context
                          .read<RestaurantDetailProvider>()
                          .fetchRestaurantDetail(widget.restaurantId);
                    },
                    icon: Icon(Icons.refresh),
                    label: Text('Coba Lagi', style: TextStyle(fontWeight: FontWeight.w600),),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ],
              ),
            ),
          _ => SizedBox(),
        };
      }),
    );
  }
}