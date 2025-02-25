import 'package:flutter/widgets.dart';
import 'package:restaurant/data/model/restaurant.dart';
import 'package:restaurant/services/sqlite_service.dart';

class FavoriteListProvider extends ChangeNotifier {
  final SqliteService _service;

  FavoriteListProvider(this._service) {
    loadAllFavoriteValue();
  }

  String _message = "";
  String get message => _message;

  List<Restaurant> _favoriteList = [];

  List<Restaurant> get favoriteList => _favoriteList;

  Future<void> loadAllFavoriteValue() async {
    try {
      final newList = await _service.getAllItems();
      _favoriteList = List.from(newList);
      _message = "All of your data is loaded";
      notifyListeners();
    } catch (e) {
      _message = "Failed to load your all data";
      notifyListeners();
    }
  }

  Future<void> addFavorite(Restaurant value) async {
    try {
      final result = await _service.insertItem(value);
      loadAllFavoriteValue();

      final isError = result == 0;
      if (isError) {
        _message = "Failed to save your data";
        notifyListeners();
      } else {
        _message = "Your data is saved";
        notifyListeners();
      }
    } catch (e) {
      _message = "Failed to save your data";
      notifyListeners();
    }
  }

  Future<void> removeFavorite(String id) async {
    try {
      await _service.removeItem(id);
      loadAllFavoriteValue();

      _message = "Your data is removed";
      notifyListeners();
    } catch (e) {
      _message = "Failed to remove your data";
      notifyListeners();
    }
  }

  Future<bool> checkItemFavorite(String id) async {
    return await _service.getItemById(id);
  }
}
