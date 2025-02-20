import 'package:flutter/material.dart';
import 'package:restaurant/data/api/api_service.dart';
import 'package:restaurant/static/restaurant_detail_result_state.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService _apiService;

  RestaurantDetailProvider(this._apiService);

  RestaurantDetailResultState _resultState = RestaurantDetailNoneState();
  RestaurantDetailResultState get resultState => _resultState; 

  Future<void> fetchRestaurantDetail(String id) async {
    try {
      _resultState = RestaurantDetailLoadingState();
      notifyListeners();

      final result = await _apiService.getRestaurantDetail(id);

      if (result.error) {
        _resultState = RestaurantDetailErrorState(result.message);
      } else {
        _resultState = RestaurantDetailLoadedState(result.restaurant);
      }

      notifyListeners();
    } on Exception catch (_) {
      _resultState = RestaurantDetailErrorState(
          'Tidak dapat terhubung ke internet. Periksa koneksi Anda dan coba lagi.'
      );
      notifyListeners();
    }
  }
}
