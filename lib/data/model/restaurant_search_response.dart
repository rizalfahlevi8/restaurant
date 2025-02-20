import 'package:restaurant/data/model/restaurant.dart';

class RestaurantSearchResponse {
  final bool error;
  final int founded;
  final List<Restaurant> restaurants;

  RestaurantSearchResponse({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  factory RestaurantSearchResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantSearchResponse(
      error: json['error'],
      founded: json['founded'],
      restaurants:  List<Restaurant>.from(
              json['restaurants']!.map((x) => Restaurant.fromJson(x)),
            ),
    );
  }
}
