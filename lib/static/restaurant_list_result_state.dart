import 'package:restaurant/data/model/restaurant.dart';

sealed class RestaurantListResultState {}

class RestaurantListNoneState extends RestaurantListResultState {}

class RestaurantListLoadingState extends RestaurantListResultState {}

class RestaurantListErrorState extends RestaurantListResultState {
  final String error;
  String get getMessage => error;

  RestaurantListErrorState(this.error);
}

class RestaurantListResultLoadedState extends RestaurantListResultState {
  final List<Restaurant> data;
  List<Restaurant> get getRestaurants => data;

  RestaurantListResultLoadedState(this.data);
}