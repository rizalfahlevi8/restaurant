import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:restaurant/data/model/restaurant.dart';
import 'package:restaurant/screen/home/restaurant_card_widget.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

class MockFunction extends Mock {
  void call();
}

void main() {
  group('RestaurantCard Widget Tests', () {
    late Restaurant restaurant;
    late MockFunction mockOnTap;
    late Widget widget;
    
    setUp(() {
      restaurant = Restaurant(
        id: '1',
        name: 'Test Restaurant',
        city: 'Test City',
        description: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...",
        pictureId: "14",
        rating: 4.5,
      );
      mockOnTap = MockFunction();
      widget = MaterialApp(
        home: Scaffold(
          body: RestaurantCard(
            restaurant: restaurant,
            onTap: mockOnTap,
          ),
        ),
      );
    });

    testWidgets('should display restaurant name, city, and rating', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(widget);
        expect(find.text('Test Restaurant'), findsOneWidget);
        expect(find.text('Test City'), findsOneWidget);
        expect(find.text('4.5'), findsOneWidget);
      });
    });

    testWidgets('should call onTap when tapped', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(widget);
        await tester.tap(find.byType(GestureDetector));
        await tester.pump();
        verify(() => mockOnTap.call()).called(1);
      });
    });
  });
}
