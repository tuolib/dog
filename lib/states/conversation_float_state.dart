import '../index.dart';

class FloatNotifier extends ChangeNotifier {
  @override
  void notifyListeners() {
    super.notifyListeners(); //通知依赖的Widget更新
  }
}

class FloatButtonModel extends FloatNotifier {
  bool _showFloatButton = false;
  bool get showFloatButton => _showFloatButton;

  setButtonState(bool show) {
    _showFloatButton = show;
    notifyListeners();
  }
}