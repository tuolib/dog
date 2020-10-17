import '../index.dart';

class ProfileChangeNotifier extends ChangeNotifier {
  Profile get _profile => Global.profile;

  @override
  void notifyListeners() {
    Global.saveProfile(); //保存Profile变更
    super.notifyListeners(); //通知依赖的Widget更新
  }
}

class UserModel extends ProfileChangeNotifier {
  User get user => _profile.user;

  // APP是否登录(如果有用户信息，则证明登录过)
  bool get isLogin => _profile.token != null;

  //用户信息发生变化，更新用户信息并通知依赖它的子孙Widgets更新
  set user(User user) {
//    print('user: ${user.username}');
//    _profile.lastLogin = _profile.user?.login;
    _profile.user = user;
//    print('_profile.user: ${_profile.user.username}');
    notifyListeners();
//    if (user?.avatarUrl != _profile.user?.avatarUrl) {
//      _profile.lastLogin = _profile.user?.login;
//      _profile.user = user;
//      notifyListeners();
//    }
  }

  changeUsername(String username) {
    _profile.user.username = username;
    notifyListeners();
  }

  changeName(String firstName, String lastName) {
    _profile.user.firstName = firstName;
    _profile.user.lastName = lastName;
    notifyListeners();
  }

  changeAvatar(int avatar, String avatarUrl, String avatarUrlLocal) {
    _profile.user.avatar = avatar;
    _profile.user.avatarUrl = avatarUrl;
    _profile.user.avatarUrlLocal = avatarUrlLocal;
    notifyListeners();
  }

  changeUser() {
    notifyListeners();
  }
}

class ThemeModel extends ProfileChangeNotifier {
  // 获取当前主题，如果为设置主题，则默认使用蓝色主题
  ColorSwatch get theme => Global.themes
      .firstWhere((e) => e.value == _profile.theme, orElse: () => Colors.blue);

  // 主题改变后，通知其依赖项，新主题会立即生效
  set theme(ColorSwatch color) {
    if (color != theme) {
      _profile.theme = color[500].value;
      notifyListeners();
    }
  }
}

class LocaleModel extends ProfileChangeNotifier {
  // 获取当前用户的APP语言配置Locale类，如果为null，则语言跟随系统语言
  Locale getLocale() {
    if (_profile.locale == null) {
      _profile.locale = 'en_US';
      return Locale('en', 'US');
    }
    var t = _profile.locale.split("_");
    return Locale(t[0], t[1]);
  }

  String _localeName = 'English';

  // 获取当前Locale的字符串表示
  String get locale => _profile.locale;

  // 获取当前Locale的 名称表示
  String get localeName => _localeName;

  // 用户改变APP语言后，通知依赖项更新，新语言会立即生效
  set locale(String locale) {
    if (locale != _profile.locale) {
      _profile.locale = locale;
      if (locale == 'zh_CN') {
        _localeName = '中文简体';
      } else {
        _localeName = 'English';
      }
      notifyListeners();
    }
  }
}
