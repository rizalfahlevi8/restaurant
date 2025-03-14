import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/data/model/received_notivication.dart';
import 'package:restaurant/provider/home/restaurant_list_provider.dart';
import 'package:restaurant/screen/home/restaurant_card_widget.dart';
import 'package:restaurant/services/local_notification_service.dart';
import 'package:restaurant/static/navigation_route.dart';
import 'package:restaurant/static/restaurant_list_result_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  void _configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? payload) {
      if (payload != null && payload.isNotEmpty) {

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamed(
            context,
            NavigationRoute.detailRoute.name,
            arguments: payload,
          );
        });
      }
    });
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationStream.stream
        .listen((ReceivedNotification receivedNotification) {
      Navigator.pushNamed(context, NavigationRoute.detailRoute.name,
          arguments: receivedNotification.payload);
    });
  }

  @override
  void initState() {
    super.initState();
    _configureSelectNotificationSubject();
    _configureDidReceiveLocalNotificationSubject();
    Future.microtask(() {
      context.read<RestaurantListProvider>().fetchRestaurantList();
    });
  }

  @override
  void dispose() {
    didReceiveLocalNotificationStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Restaurant",
              style: TextStyle(fontSize: 20),
            ),
            const Text(
              "Recommendation Restaurant for you!",
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: ValueKey("searchField"),
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Restaurants',
                      hintText: 'Enter restaurant name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  key: ValueKey("searchButton"),
                  icon: Icon(Icons.search),
                  onPressed: () {
                    final query = _searchController.text;
                    context
                        .read<RestaurantListProvider>()
                        .filterRestaurantList(query);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<RestaurantListProvider>(
              builder: (context, value, child) {
                return switch (value.resultState) {
                  RestaurantListLoadingState() => Center(
                      child: CircularProgressIndicator(),
                    ),
                  RestaurantListResultLoadedState(data: var restaurantList) =>
                    ListView.builder(
                        key: ValueKey("result"),
                        itemCount: restaurantList.length,
                        itemBuilder: (context, index) {
                          final restaurant = restaurantList[index];

                          return RestaurantCard(
                              restaurant: restaurant,
                              onTap: () {
                                Navigator.pushNamed(
                                    context, NavigationRoute.detailRoute.name,
                                    arguments: restaurant.id);
                              });
                        }),
                  RestaurantListErrorState(error: var message) => Center(
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
                            key: ValueKey("result"),
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
                                  .read<RestaurantListProvider>()
                                  .fetchRestaurantList();
                            },
                            icon: Icon(Icons.refresh),
                            label: Text(
                              'Coba Lagi',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Theme.of(context).primaryColor,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  _ => SizedBox(),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}
