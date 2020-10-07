import '../index.dart';

// 语音 视频 info
class CallInfoModel extends ChangeNotifier {
  @override
  void notifyListeners() {
    super.notifyListeners(); //通知依赖的Widget更新
  }
  final dbHelper = DatabaseHelper.instance;

  Map<String, dynamic> _callInfo = {
    "inCalling": false,
  };
  bool _inCalling = false;
  bool _fullScreen = true;
  double _width = 100;
  double _height = 177;


  Map<String, dynamic> get callInfo => _callInfo;
  bool get inCalling => _inCalling;
  bool get fullScreen => _fullScreen;
  double get width => _width;
  double get height => _height;


  updateInCalling(bool call) {
    if (_inCalling == call) return;
    _inCalling = call;
    notifyListeners();
  }

  updateFullScreen(bool value) {
    if (_fullScreen == value) return;
    _fullScreen = value;
    notifyListeners();
  }
// 更新
  void updateInfo(dynamic info) {
    if (_callInfo == info) return;
    _callInfo = info;
    // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态。
    notifyListeners();
  }

//  更新 某个属性
  void updateInfoProperty(String property, dynamic value) {
    if (_callInfo[property] == value) return;
    _callInfo[property] = value;
    // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态。
    notifyListeners();
  }

  void updateInfoPropertyMultiple(Map<String, dynamic> valueObj) {
    valueObj.forEach((key, value) {
      if (value != null) {
        _callInfo[key] = valueObj[key];
      }
    });
    // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态。
    notifyListeners();
  }
}