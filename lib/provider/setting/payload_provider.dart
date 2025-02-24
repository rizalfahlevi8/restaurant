import 'package:flutter/widgets.dart';
 
class PayloadProvider extends ChangeNotifier {
  String? _payload;

  PayloadProvider({String? payload}) : _payload = payload;

  String? get payload => _payload;

  void setPayload(String? newPayload) {
    _payload = newPayload;
    notifyListeners();
  }

  void clearPayload() {
    _payload = null;
    notifyListeners();
  }
}
