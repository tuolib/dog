import 'package:flutter/cupertino.dart';
import '../index.dart';

class ProfileChangeNotifier extends ChangeNotifier {
  Profile get _profile => Global.profile;

  @override
  void notifyListeners() {
    // Global.saveProfile(); //保存Profile变更
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
    Global.saveProfile();
    notifyListeners();
//    if (user?.avatarUrl != _profile.user?.avatarUrl) {
//      _profile.lastLogin = _profile.user?.login;
//      _profile.user = user;
//      notifyListeners();
//    }
  }

  changeUsername(String username) {
    _profile.user.username = username;
    Global.saveProfile();
    notifyListeners();
  }

  changeName(String firstName, String lastName) {
    _profile.user.firstName = firstName;
    _profile.user.lastName = lastName;
    Global.saveProfile();
    notifyListeners();
  }

  changeAvatar(int avatar, String avatarUrl, String avatarUrlLocal) {
    _profile.user.avatar = avatar;
    _profile.user.avatarUrl = avatarUrl;
    _profile.user.avatarUrlLocal = avatarUrlLocal;
    Global.saveProfile();
    notifyListeners();
  }

  changeUser() {
    notifyListeners();
  }
}

class ThemeModel extends ProfileChangeNotifier {
  // // 获取当前主题，如果为设置主题，则默认使用蓝色主题
  // Color get theme => Global.themes
  //     .firstWhere((e) => e.value == _profile.theme, orElse: () => themesAll[0]);
  //
  int get theme => _profile.theme == null
      ? 0
      : _profile.theme > Global.themes.length ? 0 : _profile.theme;

  int get themeDark => _profile.themeDark == null
      ? 0
      : _profile.themeDark > Global.themes.length ? 0 : _profile.themeDark;

  //_profile.theme == null ? 0 : _profile.theme;

  int get themeMode => _profile.themeMode == null ? 1 : _profile.themeMode;

  // day模式 主题改变后，通知其依赖项，新主题会立即生效
  set theme(int index) {
    if (index != theme) {
      _profile.theme = index;
      Global.saveProfile();
      notifyListeners();
    }
  }

  // dark 模式
  set themeDark(int index) {
    if (index != themeDark) {
      _profile.themeDark = index;
      Global.saveProfile();
      notifyListeners();
    }
  }

  set themeMode(num mode) {
    if (mode != themeMode) {
      _profile.themeMode = mode;
      Global.saveProfile();
      notifyListeners();
    }
  }

  Brightness get brightness {
    Brightness colorValue;
    colorValue = themeMode == 1 ? Brightness.light : Brightness.dark;
    return colorValue;
  }

  // 主颜色 themes
  Color get primaryColor {
    Color colorValue;
    colorValue = Color(Global.themes[themeMode == 1 ? theme : themeDark]);
    return colorValue;
  }

  //其他主题颜色
// scaffoldBackgroundColor
  Color get scaffoldBackgroundColor {
    Color colorValue;
    if (themeMode == 1) {
      //239, 239, 244
      colorValue = Color.fromRGBO(239, 239, 244, 1);
    } else if (themeMode == 2) {
      colorValue = Color.fromRGBO(0, 0, 0, 1);
    }
    return colorValue;
  }

//bar Background
  Color get barBackgroundColor {
    Color colorValue;
    if (themeMode == 1) {
      //246, 246, 248
      colorValue = Color.fromRGBO(248, 248, 248, 1);
    } else if (themeMode == 2) {
      colorValue = Color.fromRGBO(28, 28, 29, 1);
    }
    return colorValue;
  }

//bar Background
  Color get menuBackgroundColor {
    Color colorValue;
    if (themeMode == 1) {
      //246, 246, 248
      colorValue = Color.fromRGBO(255, 255, 255, 1);
    } else if (themeMode == 2) {
      colorValue = Color.fromRGBO(28, 28, 29, 1);
    }
    return colorValue;
  }

  // 自己消息背景 themesMessage
  Color get messagesColor {
    Color colorValue;
    if (themeMode == 1) {
      colorValue = Color(Global.themesMessage[theme]);
    } else if (themeMode == 2) {
      var newValue = Global.themesMessage[themeDark];
      if (Color(newValue).red > 177 && Color(newValue).green > 177 && Color(newValue).blue > 177) {
        colorValue = Color.fromRGBO(40, 40, 48, 1);
      } else {
        colorValue = Color(newValue);
      }
      // if (newValue > Color.fromRGBO(177, 177, 177, 1).value) {
      //   colorValue = Color.fromRGBO(40, 40, 48, 1);
      // } else {
      //   colorValue = Color(newValue);
      // }
    }
    return colorValue;
  }

  // 对方消息背景 固定
  Color get messagesColorSide {
    Color colorValue;
    if (themeMode == 1) {
      //214, 221, 229
      colorValue = Color.fromRGBO(214, 221, 229, 1);
    } else if (themeMode == 2) {
      //38, 38, 40
      colorValue = Color.fromRGBO(38, 38, 40, 1);
    }
    return colorValue;
  }

  // 聊天页面背景颜色 themesBg
  Color get messagesChatBg {
    Color colorValue;
    if (themeMode == 1) {
      colorValue = Color(Global.themesBg[theme]);
    } else if (themeMode == 2) {
      colorValue = Color(Global.themesBg[themeDark]);
    }
    return colorValue;
  }

  // 黑色文字 bar menuList normal
  Color get messagesWordSelf {
    Color colorValue;
    // if (themeMode == 1) {
    //   colorValue = Color.fromRGBO(0, 0, 0, 1);
    // } else if (themeMode == 2) {
    //   //152, 152, 157
    //   colorValue = Color.fromRGBO(255, 255, 255, 1);
    // }

    colorValue = Color.fromRGBO(255, 255, 255, 1);
    return colorValue;
  }
  Color get messagesWordSide {
    Color colorValue;
    if (themeMode == 1) {
      colorValue = Color.fromRGBO(0, 0, 0, 1);
    } else if (themeMode == 2) {
      //152, 152, 157
      colorValue = Color.fromRGBO(255, 255, 255, 1);
    }
    return colorValue;
  }

  // 黑色文字 bar menuList normal
  Color get normalColor {
    Color colorValue;
    if (themeMode == 1) {
      colorValue = Color.fromRGBO(0, 0, 0, 1);
    } else if (themeMode == 2) {
      //152, 152, 157
      colorValue = Color.fromRGBO(255, 255, 255, 1);
    }
    return colorValue;
  }

// 灰一点文字
  Color get inactiveColor {
    Color colorValue;
    if (themeMode == 1) {
      // 其他注释文字 110, 111, 115
      // bottom bar 143, 143, 143
      // 菜单栏列表 141, 141, 146
      colorValue = Color.fromRGBO(153, 153, 153, 1);
    } else if (themeMode == 2) {
      //152, 152, 157
      colorValue = Color.fromRGBO(117, 117, 117, 1);
    }
    return colorValue;
  }

  // 灰色线
  Color get borderColor {
    Color colorValue;
    if (themeMode == 1) {
      colorValue = Color.fromRGBO(200, 199, 204, 1);
    } else if (themeMode == 2) {
      //152, 152, 157
      colorValue = Color.fromRGBO(61, 61, 64, 1);
    }
    return colorValue;
  }

  // self message color 白色
// 148, 148, 149 day / blue / other
// 182, 210, 252 day / blue / self
// 152, 152, 153 night / blue / other
// 147, 147, 148 night/ blue / self
// 聊天消息时间颜色
  // message 灰一点文字
  Color get inactiveColorMessage {
    Color colorValue;
    if (themeMode == 1) {
      colorValue = Color.fromRGBO(148, 148, 149, 1);
    } else if (themeMode == 2) {
      colorValue = Color.fromRGBO(152, 152, 153, 1);
    }
    return colorValue;
  }

  Color get inactiveColorMessageSelf {
    Color colorValue;
    if (themeMode == 1) {
      // colorValue = Color.fromRGBO(153, 153, 153, 1);
      colorValue = Color.fromRGBO(255, 255, 255, 4.6);
    } else if (themeMode == 2) {
      colorValue = Color.fromRGBO(255, 255, 255, 4.6);
      // colorValue = Color.fromRGBO(152, 152, 153, 1);
    }
    return colorValue;
  }

  /// 特殊颜色 主题页面
  // 自己消息背景 themesMessage
  Color get messagesColorAppearanceDay {
    Color colorValue;
    colorValue = Color(Global.profile.themesDayMessage[theme]);
    return colorValue;
  }

  // 对方消息背景 固定
  Color get messagesColorSideAppearanceDay {
    Color colorValue;
    colorValue = Color.fromRGBO(214, 221, 229, 1);
    return colorValue;
  }

  // 自己消息背景 themesMessage
  Color get messagesColorAppearanceDark {
    Color colorValue;
    var newValue = Global.profile.themesDarkMessage[themeDark];
    if (Color(newValue).red > 177 && Color(newValue).green > 177 && Color(newValue).blue > 177) {
      colorValue = Color.fromRGBO(40, 40, 48, 1);
    } else {
      colorValue = Color(newValue);
    }
    // if (newValue > Color.fromRGBO(177, 177, 177, 1).value) {
    //   colorValue = Color.fromRGBO(40, 40, 48, 1);
    // } else {
    //   colorValue = Color(newValue);
    // }
    // colorValue = Color(Global.profile.themesDarkMessage[themeDark]);
    return colorValue;
  }

  // 对方消息背景 固定
  Color get messagesColorSideAppearanceDark {
    Color colorValue;
    colorValue = Color.fromRGBO(38, 38, 40, 1);
    return colorValue;
  }

  // 聊天页面背景颜色 themesBg
  Color get messagesChatBgAppearanceDay {
    Color colorValue;
    // logger.d(Global.profile.themesDayBg);
    // logger.d(theme);
    colorValue = Color(Global.profile.themesDayBg[theme]);
    // colorValue = CupertinoColors.
    return colorValue;
  }

  // 聊天页面背景颜色 themesBg
  Color get messagesChatBgAppearanceDark {
    Color colorValue;
    colorValue = Color(Global.profile.themesDarkBg[themeDark]);
    // colorValue = CupertinoColors.
    return colorValue;
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
      Global.saveProfile();
      notifyListeners();
    }
  }
}
