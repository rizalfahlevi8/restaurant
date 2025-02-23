import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:restaurant/screen/home/home_screen.dart';

import 'robot/evaluate_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Search functionality test", (tester) async {
    final searchRobot = EvaluateRobot(tester);

    await searchRobot.loadUI(const HomeScreen());

    await searchRobot.typeSearchQuery("Melting Pot");
    await searchRobot.tapSearchButton();
    await searchRobot.checkSearchResultContains("Melting Pot");

    await searchRobot.typeSearchQuery("Unknown Restaurant");
    await searchRobot.tapSearchButton();
    await searchRobot.checkNoSearchResult();
  });
}
