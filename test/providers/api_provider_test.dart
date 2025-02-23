import 'package:mocktail/mocktail.dart';
import 'package:restaurant/data/api/api_service.dart';
import 'package:restaurant/data/model/restaurant_list_response.dart';
import 'package:restaurant/provider/home/restaurant_list_provider.dart';
import 'package:restaurant/static/restaurant_list_result_state.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

class MockApiProvider extends Mock implements ApiService {}

void main() {
  late MockApiProvider apiProvider;
  late RestaurantListProvider restaurantListProvider;

  setUp(() {
    apiProvider = MockApiProvider();
    restaurantListProvider = RestaurantListProvider(apiProvider);
  });

  group("RestaurantListProvider tests", () {
    test('should return RestaurantListNoneState when provider initialize.', () {
      expect(
          restaurantListProvider.resultState, isA<RestaurantListNoneState>());
    });

    test(
        'should return RestaurantListResultLoadedState when API call is successful',
        () async {
      final mockRestaurantListResponse = RestaurantListResponse(
        error: false,
        message: '',
        count: 0,
        restaurants: [],
      );

      when(() => apiProvider.getRestaurantList())
          .thenAnswer((_) async => mockRestaurantListResponse);

      await restaurantListProvider.fetchRestaurantList();

      expect(restaurantListProvider.resultState, isA<RestaurantListResultLoadedState>());
      expect((restaurantListProvider.resultState as RestaurantListResultLoadedState).getRestaurants, isEmpty);
    });

    test('should return RestaurantListErrorState when API call fails', () async {

      when(() => apiProvider.getRestaurantList())
          .thenThrow(Exception("Failed to load restaurant list"));

      await restaurantListProvider.fetchRestaurantList();

      expect(restaurantListProvider.resultState, isA<RestaurantListErrorState>());
      expect((restaurantListProvider.resultState as RestaurantListErrorState).getMessage,
          "Tidak dapat terhubung ke internet. Periksa koneksi Anda dan coba lagi.");
    });
  });
}
