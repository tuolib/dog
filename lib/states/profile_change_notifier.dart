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

  set themeMode(int mode) {
    if (mode != themeMode) {
      _profile.themeMode = mode;
      Global.saveProfile();
      notifyListeners();
    }
  }
  //修改value
  themeColorValue(Map color, int type) {
    // type 0 accent themesDay
    // 1 background themesDayBg
    // 2 messages themesDayMessage
    if (themeMode == 1) {
      Global.profile.dayList[theme] = color;
      // if (type == 0) {
      //   Global.profile.dayList[theme]['primary'] = color;
      // } else if (type == 1) {
      //   Global.profile.dayList[theme]['background'] = color;
      //   Global.profile.dayList[theme]['background2'] = color2;
      // } else if (type == 2) {
      //   Global.profile.dayList[theme]['message'] = color;
      //   Global.profile.dayList[theme]['message2'] = color2;
      // }
    } else if (themeMode == 2) {
      Global.profile.darkList[themeDark] = color;
      // if (type == 0) {
      //   Global.profile.darkList[themeDark]['primary'] = color;
      // } else if (type == 1) {
      //   Global.profile.darkList[themeDark]['background'] = color;
      //   Global.profile.darkList[theme]['background2'] = color2;
      // } else if (type == 2) {
      //   Global.profile.darkList[themeDark]['message'] = color;
      //   Global.profile.darkList[theme]['message2'] = color2;
      // }
    }
    // _profile.themeMode = mode;
    Global.saveProfile();
    notifyListeners();
  }

  // 新增
  themeColorAdd(Map color, int type) {
    logger.d('$color/$type');
    // type 0 accent themesDay
    // 1 background themesDayBg
    // 2 messages themesDayMessage
    if (themeMode == 1) {
      Global.profile.dayList.insert(0, color);
      // Global.profile.themesDay.insert(0, color);
      // Global.profile.themesDayBg.insert(0, color);
      // Global.profile.themesDayMessage.insert(0, color);
      // if (type == 0) {
      //   Global.profile.themesDay.insert(0, color);
      // } else if (type == 1) {
      //   Global.profile.themesDayBg.insert(0, color);
      // } else if (type == 2) {
      //   Global.profile.themesDayMessage.insert(0, color);
      // }
      theme = 0;
    } else if (themeMode == 2) {
      Global.profile.darkList.insert(0, color);
      // Global.profile.themesDark.insert(0, color);
      // Global.profile.themesDarkBg.insert(0, color);
      // Global.profile.themesDarkMessage.insert(0, color);
      // if (type == 0) {
      //   Global.profile.themesDark.insert(0, color);
      // } else if (type == 1) {
      //   Global.profile.themesDarkBg.insert(0, color);
      // } else if (type == 2) {
      //   Global.profile.themesDarkMessage.insert(0, color);
      // }
      themeDark = 0;
    }
    // _profile.themeMode = mode;
    Global.saveProfile();
    notifyListeners();
  }

  // 删除
  themeColorDelete(int color, int type) {
    // type 0 accent themesDay
    // 1 background themesDayBg
    // 2 messages themesDayMessage
    // if (themeMode == 1) {
    //   Global.profile.themesDay.removeAt(theme);
    //   Global.profile.themesDayBg.removeAt(theme);
    //   Global.profile.themesDayMessage.removeAt(theme);
    //   // if (type == 0) {
    //   //   Global.profile.themesDay.removeAt(theme);
    //   // } else if (type == 1) {
    //   //   Global.profile.themesDayBg.removeAt(theme);
    //   // } else if (type == 2) {
    //   //   Global.profile.themesDayMessage.removeAt(theme);
    //   // }
    // } else if (themeMode == 2) {
    //   Global.profile.themesDark.removeAt(themeDark);
    //   Global.profile.themesDarkBg.removeAt(themeDark);
    //   Global.profile.themesDarkMessage.removeAt(themeDark);
    //   // if (type == 0) {
    //   //   Global.profile.themesDark.removeAt(themeDark);
    //   // } else if (type == 1) {
    //   //   Global.profile.themesDarkBg.removeAt(themeDark);
    //   // } else if (type == 2) {
    //   //   Global.profile.themesDarkMessage.removeAt(themeDark);
    //   // }
    // }
    // _profile.themeMode = mode;
    Global.saveProfile();
    notifyListeners();
  }

  Brightness get brightness {
    Brightness colorObj;
    colorObj = themeMode == 1 ? Brightness.light : Brightness.dark;
    return colorObj;
  }

  // 主颜色 themes
  Color get primaryColor {
    Color colorObj;
    colorObj = Color(Global.themes[themeMode == 1 ? theme : themeDark]['primary']);
    return colorObj;
  }

  //其他主题颜色
// scaffoldBackgroundColor
  Color get scaffoldBackgroundColor {
    Color colorObj;
    if (themeMode == 1) {
      //239, 239, 244
      colorObj = Color.fromRGBO(239, 239, 244, 1);
    } else if (themeMode == 2) {
      colorObj = Color.fromRGBO(0, 0, 0, 1);
    }
    return colorObj;
  }

//bar Background
  Color get barBackgroundColor {
    Color colorObj;
    if (themeMode == 1) {
      //246, 246, 248
      colorObj = Color.fromRGBO(248, 248, 248, 1);
    } else if (themeMode == 2) {
      colorObj = Color.fromRGBO(28, 28, 29, 1);
    }
    return colorObj;
  }

//bar Background
  Color get menuBackgroundColor {
    Color colorObj;
    if (themeMode == 1) {
      //246, 246, 248
      colorObj = Color.fromRGBO(255, 255, 255, 1);
    } else if (themeMode == 2) {
      colorObj = Color.fromRGBO(28, 28, 29, 1);
    }
    return colorObj;
  }

  Color get inputBackgroundColor {
    Color colorObj;
    if (themeMode == 1) {
      // 241, 241, 241
      //246, 246, 248
      colorObj = Color.fromRGBO(255, 255, 255, 1);
    } else if (themeMode == 2) {
      colorObj = Color.fromRGBO(15, 15, 15, 1);
    }
    return colorObj;
  }

  // 自己消息背景 themesMessage
  Color get messagesColor {
    Color colorObj;
    if (themeMode == 1) {
      // colorObj = Color(Global.themesMessage[theme]);
      var newValue = Global.themes[theme]['message'];
      if (Color(newValue).red > 177 &&
          Color(newValue).green > 177 &&
          Color(newValue).blue > 177) {
        colorObj = Color.fromRGBO(40, 40, 48, 1);
      } else {
        colorObj = Color(newValue);
      }
    } else if (themeMode == 2) {
      var newValue = Global.themes[themeDark]['message'];
      if (Color(newValue).red > 177 &&
          Color(newValue).green > 177 &&
          Color(newValue).blue > 177) {
        colorObj = Color.fromRGBO(40, 40, 48, 1);
      } else {
        colorObj = Color(newValue);
      }
      // if (newValue > Color.fromRGBO(177, 177, 177, 1).value) {
      //   colorObj = Color.fromRGBO(40, 40, 48, 1);
      // } else {
      //   colorObj = Color(newValue);
      // }
    }
    return colorObj;
  }
  Color get messagesColor2 {
    Color colorObj;
    if (themeMode == 1) {
      // colorObj = Color(Global.themesMessage[theme]);
      var newValue = Global.themes[theme]['message2'];
      if (newValue == null) {
        return null;
      }
      if (Color(newValue).red > 177 &&
          Color(newValue).green > 177 &&
          Color(newValue).blue > 177) {
        colorObj = Color.fromRGBO(40, 40, 48, 1);
      } else {
        colorObj = Color(newValue);
      }
    } else if (themeMode == 2) {
      var newValue = Global.themes[themeDark]['message2'];
      if (newValue == null) {
        return null;
      }
      if (Color(newValue).red > 177 &&
          Color(newValue).green > 177 &&
          Color(newValue).blue > 177) {
        colorObj = Color.fromRGBO(40, 40, 48, 1);
      } else {
        colorObj = Color(newValue);
      }
      // if (newValue > Color.fromRGBO(177, 177, 177, 1).value) {
      //   colorObj = Color.fromRGBO(40, 40, 48, 1);
      // } else {
      //   colorObj = Color(newValue);
      // }
    }
    return colorObj;
  }

  // 对方消息背景 固定
  Color get messagesColorSide {
    Color colorObj;
    if (themeMode == 1) {
      //214, 221, 229
      colorObj = Color.fromRGBO(241, 241, 244, 1);
    } else if (themeMode == 2) {
      //38, 38, 40
      colorObj = Color.fromRGBO(38, 38, 40, 1);
    }
    return colorObj;
  }

  // 聊天页面背景颜色 themesBg
  Color get messagesChatBg {
    Color colorObj;
    if (themeMode == 1) {
      colorObj = Color(Global.themes[theme]['background']);
    } else if (themeMode == 2) {
      colorObj = Color(Global.themes[themeDark]['background']);
    }
    return colorObj;
  }

  // 聊天页面背景颜色 themesBg2 渐变色
  Color get messagesChatBg2 {
    Color colorObj;
    if (themeMode == 1) {
      if (Global.themes[theme]['background2'] != null) {
        colorObj = Color(Global.themes[theme]['background2']);
      }
    } else if (themeMode == 2) {
      if (Global.themes[themeDark]['background2'] != null) {
        colorObj = Color(Global.themes[themeDark]['background2']);
      }
      // colorObj = Color(Global.themes[themeDark]['background2']);
    }
    return colorObj;
  }

  // 聊天页面底部tab背景
  Color get messagesChatBgBottom {
    Color colorObj;
    if (themeMode == 1) {
      // messagesChatBg
      // colorObj = Color(Global.themesBg[theme]);
      var newValue = messagesChatBg.value;
      if (newValue == Color.fromRGBO(255, 255, 255, 1).value) {

        colorObj = Color(newValue);
      } else {
        colorObj = barBackgroundColor;
      }
      // if (Color(newValue).red > 177 &&
      //     Color(newValue).green > 177 &&
      //     Color(newValue).blue > 177) {
      //   colorObj = Color(newValue);
      // } else {
      //   colorObj = barBackgroundColor;
      // }
    } else if (themeMode == 2) {
      // colorObj = Color(Global.themesBg[themeDark]);
      var newValue = messagesChatBg.value;
      if (newValue == Color.fromRGBO(0, 0, 0, 1).value) {
        colorObj = Color(newValue);
      } else {
        colorObj = barBackgroundColor;
      }
      // if (Color(newValue).red < 25 &&
      //     Color(newValue).green < 25 &&
      //     Color(newValue).blue < 25) {
      //   colorObj = Color(newValue);
      // } else {
      //   colorObj = barBackgroundColor;
      // }
    }
    return colorObj;
  }

  // 聊天界面 自己文字颜色
  Color get messagesWordSelf {
    Color colorObj;
    // if (themeMode == 1) {
    //   colorObj = Color.fromRGBO(0, 0, 0, 1);
    // } else if (themeMode == 2) {
    //   //152, 152, 157
    //   colorObj = Color.fromRGBO(255, 255, 255, 1);
    // }

    colorObj = Color.fromRGBO(255, 255, 255, 1);
    return colorObj;
  }

  // 聊天界面其他人 自己文字颜色
  Color get messagesWordSide {
    Color colorObj;
    if (themeMode == 1) {
      colorObj = Color.fromRGBO(0, 0, 0, 1);
    } else if (themeMode == 2) {
      //152, 152, 157
      colorObj = Color.fromRGBO(255, 255, 255, 1);
    }
    return colorObj;
  }

  // 黑色文字 bar menuList normal
  Color get normalColor {
    Color colorObj;
    if (themeMode == 1) {
      colorObj = Color.fromRGBO(0, 0, 0, 1);
    } else if (themeMode == 2) {
      //152, 152, 157
      colorObj = Color.fromRGBO(255, 255, 255, 1);
    }
    return colorObj;
  }

// 灰一点文字
  Color get inactiveColor {
    Color colorObj;
    if (themeMode == 1) {
      // 其他注释文字 110, 111, 115
      // bottom bar 143, 143, 143
      // 菜单栏列表 141, 141, 146
      colorObj = Color.fromRGBO(153, 153, 153, 1);
    } else if (themeMode == 2) {
      //152, 152, 157
      colorObj = Color.fromRGBO(117, 117, 117, 1);
    }
    return colorObj;
  }

  // 灰色线
  Color get borderColor {
    Color colorObj;
    if (themeMode == 1) {
      colorObj = Color.fromRGBO(200, 199, 204, 1);
    } else if (themeMode == 2) {
      //152, 152, 157
      colorObj = Color.fromRGBO(61, 61, 64, 1);
    }
    return colorObj;
  }

  // self message color 白色
// 148, 148, 149 day / blue / other
// 182, 210, 252 day / blue / self
// 152, 152, 153 night / blue / other
// 147, 147, 148 night/ blue / self
// 聊天消息时间颜色
  // message 灰一点文字
  Color get inactiveColorMessage {
    Color colorObj;
    if (themeMode == 1) {
      colorObj = Color.fromRGBO(148, 148, 149, 1);
    } else if (themeMode == 2) {
      colorObj = Color.fromRGBO(152, 152, 153, 1);
    }
    return colorObj;
  }

  Color get inactiveColorMessageSelf {
    Color colorObj;
    if (themeMode == 1) {
      // colorObj = Color.fromRGBO(153, 153, 153, 1);
      colorObj = Color.fromRGBO(255, 255, 255, 4.6);
    } else if (themeMode == 2) {
      colorObj = Color.fromRGBO(255, 255, 255, 4.6);
      // colorObj = Color.fromRGBO(152, 152, 153, 1);
    }
    return colorObj;
  }

  // message 圆角
  double get radius {
    return 16.0;
  }

  // 背景图片
  int get backgroundImage {
    int bg;
    if (Global.backgroundImage != null) {
      bg = int.parse(Global.backgroundImage);
    }
    return bg;
  }
  String get backgroundImageUrl {
    String bg;
    bg = Global.backgroundImageUrl;
    return bg;
  }




  /// 特殊颜色 主题页面
  // 自己消息背景 themesMessage
  Color get messagesColorAppearanceDay {
    Color colorObj;
    // colorObj = Color(Global.profile.themesDayMessage[theme]);
    var newValue = Global.profile.dayList[theme]['message'];
    if (Color(newValue).red > 177 &&
        Color(newValue).green > 177 &&
        Color(newValue).blue > 177) {
      colorObj = Color.fromRGBO(40, 40, 48, 1);
    } else {
      colorObj = Color(newValue);
    }
    return colorObj;
  }
  Color get messagesColorAppearanceDay2 {
    Color colorObj;
    // colorObj = Color(Global.profile.themesDayMessage[theme]);
    var newValue = Global.profile.dayList[theme]['message2'];
    if (newValue != null) {

      if (Color(newValue).red > 177 &&
          Color(newValue).green > 177 &&
          Color(newValue).blue > 177) {
        colorObj = Color.fromRGBO(40, 40, 48, 1);
      } else {
        colorObj = Color(newValue);
      }
    }
    return colorObj;
  }

  // 对方消息背景 固定
  Color get messagesColorSideAppearanceDay {
    Color colorObj;
    colorObj = Color.fromRGBO(241, 241, 244, 1);
    return colorObj;
  }

  // 自己消息背景 themesMessage
  Color get messagesColorAppearanceDark {
    Color colorObj;
    var newValue = Global.profile.darkList[themeDark]['message'];
    if (Color(newValue).red > 177 &&
        Color(newValue).green > 177 &&
        Color(newValue).blue > 177) {
      colorObj = Color.fromRGBO(40, 40, 48, 1);
    } else {
      colorObj = Color(newValue);
    }
    // if (newValue > Color.fromRGBO(177, 177, 177, 1).value) {
    //   colorObj = Color.fromRGBO(40, 40, 48, 1);
    // } else {
    //   colorObj = Color(newValue);
    // }
    // colorObj = Color(Global.profile.themesDarkMessage[themeDark]);
    return colorObj;
  }
  Color get messagesColorAppearanceDark2 {
    Color colorObj;
    var newValue = Global.profile.darkList[themeDark]['message2'];
    if (newValue != null) {
      // colorObj = Color(value);
      if (Color(newValue).red > 177 &&
          Color(newValue).green > 177 &&
          Color(newValue).blue > 177) {
        colorObj = Color.fromRGBO(40, 40, 48, 1);
      } else {
        colorObj = Color(newValue);
      }
    }
    // if (newValue > Color.fromRGBO(177, 177, 177, 1).value) {
    //   colorObj = Color.fromRGBO(40, 40, 48, 1);
    // } else {
    //   colorObj = Color(newValue);
    // }
    // colorObj = Color(Global.profile.themesDarkMessage[themeDark]);
    return colorObj;
  }

  // 对方消息背景 固定
  Color get messagesColorSideAppearanceDark {
    Color colorObj;
    colorObj = Color.fromRGBO(38, 38, 40, 1);
    return colorObj;
  }

  // 聊天页面背景颜色 themesBg
  Color get messagesChatBgAppearanceDay {
    Color colorObj;
    // logger.d(Global.profile.themesDayBg);
    // logger.d(theme);
    colorObj = Color(Global.profile.dayList[theme]['background']);
    // colorObj = CupertinoColors.
    return colorObj;
  }

  // 聊天页面背景颜色 themesBg
  Color get messagesChatBgAppearanceDark {
    Color colorObj;
    colorObj = Color(Global.profile.darkList[themeDark]['background']);
    // colorObj = CupertinoColors.
    return colorObj;
  }

  // 聊天页面背景颜色 themesBg 渐变色
  Color get messagesChatBgAppearanceDay2 {
    Color colorObj;
    // logger.d(Global.profile.themesDayBg);
    // logger.d(theme);
    var value = Global.profile.dayList[theme]['background2'];
    if (value != null) {
      colorObj = Color(value);
    }
    // colorObj = CupertinoColors.
    return colorObj;
  }
  // 聊天页面背景颜色 themesBg 渐变色
  Color get messagesChatBgAppearanceDark2 {
    Color colorObj;
    // colorObj = Color(Global.profile.darkList[themeDark]['background2']);
    var value = Global.profile.darkList[themeDark]['background2'];
    if (value != null) {
      colorObj = Color(value);
    }
    // colorObj = CupertinoColors.
    return colorObj;
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
