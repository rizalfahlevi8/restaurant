import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/data/api/api_service.dart';
import 'package:restaurant/provider/home/restaurant_list_provider.dart';

class EvaluateRobot {
  final WidgetTester tester;

  const EvaluateRobot(this.tester);

  final searchFieldKey = const ValueKey("searchField");
  final searchButtonKey = const ValueKey("searchButton");
  final resultKey = const ValueKey("result");

  Future<void> loadUI(Widget widget) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider(create: (context) => ApiService()),
          ChangeNotifierProvider(
              create: (context) =>
                  RestaurantListProvider(context.read<ApiService>())),
        ],
        child: MaterialApp(
          home: widget,
        ),
      ),
    );
  }

  Future<void> typeSearchQuery(String query) async {
    final searchFieldFinder = find.byKey(searchFieldKey);
    await tester.tap(searchFieldFinder);
    await tester.enterText(searchFieldFinder, query);
    await tester.testTextInput.receiveAction(TextInputAction.done);
  }

  Future<void> tapSearchButton() async {
    final searchButtonFinder = find.byKey(searchButtonKey);
    await tester.tap(searchButtonFinder);
    await tester.pump();
  }

  Future<void> checkSearchResultContains(String restaurantName) async {
    final resultFinder = find.byKey(resultKey);

    await tester
        .pumpAndSettle(); 

    expect(
      resultFinder,
      findsOneWidget,
      reason: "Expected at least one search result, but found none.",
    );

    if (tester.widget(resultFinder) is ListView) {
      final restaurantFinder = find.textContaining(restaurantName);
      expect(restaurantFinder, findsWidgets);
    }
    else if (tester.widget(resultFinder) is Text) {
      final resultWidget = tester.widget<Text>(resultFinder);
      expect(resultWidget.data, contains(restaurantName));
    }
  }

  Future<void> checkNoSearchResult() async {
    final resultFinder = find.byKey(resultKey);

    await tester.pumpAndSettle(); 

    expect(
      resultFinder,
      findsOneWidget, 
      reason: "Expected no search result, but found some.",
    );

    if (tester.widget(resultFinder) is Text) {
      final resultWidget = tester.widget<Text>(resultFinder);
      expect(resultWidget.data, isNot(contains("Melting Pot")));
    }
    else if (tester.widget(resultFinder) is ListView) {
      final listViewWidget = tester.widget<ListView>(resultFinder);
      expect(listViewWidget.semanticChildCount, 0);
    }
  }
}
