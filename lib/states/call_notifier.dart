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
  var _remoteStream;
  bool _voiceMute = false;
  bool _videoEnable = true;


  Map<String, dynamic> get callInfo => _callInfo;
  bool get inCalling => _inCalling;
  bool get fullScreen => _fullScreen;
  double get width => _width;
  double get height => _height;
  dynamic get remoteStream => _remoteStream;
  bool get voiceMute => _voiceMute;
  bool get videoEnable => _videoEnable;


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

  updateRemoteStream(stream) {
    _remoteStream = stream;
    notifyListeners();
  }
  updateCall() {
    // _remoteStream = stream;
    notifyListeners();
  }

  updateVoice(bool enable) {
    if (_voiceMute == enable) return;
    _voiceMute = enable;
    notifyListeners();
  }
  updateVideo(bool enable) {
    if (_videoEnable == enable) return;
    _videoEnable = enable;
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