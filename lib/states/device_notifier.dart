
import 'package:flutter/services.dart';
import '../index.dart';

// 语音 视频 info
class DeviceModel extends ChangeNotifier {
  @override
  void notifyListeners() {
    super.notifyListeners(); //通知依赖的Widget更新
  }
  final dbHelper = DatabaseHelper.instance;

  List _device = [];


  List get device => _device;

  getDevice() async {
    var de = await dbHelper.deviceGetByUser(Global.profile.user.userId);
    // logger.d(de);
    if (de != null) {
      _device = de;
    }
    notifyListeners();

  }

  updateDeviceList(List de) {
    // _remoteStream = stream;
    _device = de;
    notifyListeners();
  }

  updateDevice() {
    // _remoteStream = stream;
    notifyListeners();
  }
}