import 'package:flutter/material.dart';
import 'package:restaurant/data/api/api_service.dart';
import 'package:restaurant/static/restaurant_list_result_state.dart';

class RestaurantListProvider extends ChangeNotifier {
  final ApiService _apiService;

  RestaurantListProvider(
    this._apiService,
  );

  RestaurantListResultState _resultState = RestaurantListNoneState();
  RestaurantListResultState get resultState => _resultState;

  Future<void> fetchRestaurantList() async {
    try {
      _resultState = RestaurantListLoadingState();
      notifyListeners();

      final result = await _apiService.getRestaurantList();

      if (result.error) {
        _resultState = RestaurantListErrorState(result.message);
        notifyListeners();
      } else {
        _resultState = RestaurantListResultLoadedState(result.restaurants);
        notifyListeners();
      }
    } on Exception catch (_) {
      _resultState = RestaurantListErrorState(
          'Tidak dapat terhubung ke internet. Periksa koneksi Anda dan coba lagi.');
      notifyListeners();
    }
  }

  Future<void> filterRestaurantList(String query) async {
    try {
      _resultState = RestaurantListLoadingState();
      notifyListeners();

      final result = await _apiService.getSearchRestaurant(query);

      _resultState = RestaurantListResultLoadedState(result.restaurants);
      notifyListeners();
    } on Exception catch (_) {
      _resultState = RestaurantListErrorState(
          'Tidak dapat terhubung ke internet. Periksa koneksi Anda dan coba lagi.');
      notifyListeners();
    }
  }
}
