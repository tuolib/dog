import '../index.dart';

class FloatNotifier extends ChangeNotifier {
  @override
  void notifyListeners() {
    super.notifyListeners(); //通知依赖的Widget更新
  }
}

class FloatButtonModel extends FloatNotifier {
  bool _showFloatButton = false;
  bool _showInputTopLine = false;
  bool get showFloatButton => _showFloatButton;
  bool get showInputTopLine => _showInputTopLine;

  setButtonState(bool show) {
    if (_showFloatButton == show) return;
    _showFloatButton = show;
    notifyListeners();
  }

  setTopLine(bool show, {noti: true}) {
    if (_showInputTopLine == show) return;
    _showInputTopLine = show;
    if (noti) {
      notifyListeners();
    }
  }

  noti() {
    notifyListeners();
  }
}