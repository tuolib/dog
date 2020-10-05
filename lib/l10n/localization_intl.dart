import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'messages_all.dart'; //1

class GmLocalizations {
  static Future<GmLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    //2
    return initializeMessages(localeName).then((b) {
      Intl.defaultLocale = localeName;
      return new GmLocalizations();
    });
  }

  static GmLocalizations of(BuildContext context) {
    return Localizations.of<GmLocalizations>(context, GmLocalizations);
  }

  String get title {
    return Intl.message(
      'Flutter APP',
      name: 'title',
      desc: 'Title for the Demo application',
    );
  }

  remainingEmailsMessage(int howMany) => Intl.plural(howMany,
      zero: 'There are no emails left',
      one: 'There is $howMany email left',
      other: 'There are $howMany emails left',
      name: "remainingEmailsMessage",
      args: [howMany],
      desc: "How many emails remain after archiving.",
      examples: const {'howMany': 42});


  String get noDescription {
    return Intl.message(
      'noDescription',
      name: 'noDescription',
      desc: 'noDescription',
    );
  }

  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: 'Home',
    );
  }

  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: 'Login',
    );
  }

  String get theme {
    return Intl.message(
      'Theme',
      name: 'theme',
      desc: 'Theme',
    );
  }

  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: 'Language',
    );
  }


  String get logout {
    return Intl.message(
      'Log out',
      name: 'logout',
      desc: 'Log out',
    );
  }
  String get logoutTip {
    return Intl.message(
      'Log out tip',
      name: 'logoutTip',
      desc: 'Log out tip',
    );
  }
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: 'Cancel',
    );
  }
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: 'Yes',
    );
  }
  String get userName {
    return Intl.message(
      'User name',
      name: 'userName',
      desc: 'User name',
    );
  }
  String get userNameOrEmail {
    return Intl.message(
      'User name or email',
      name: 'userNameOrEmail',
      desc: 'User name or email',
    );
  }
  String get userNameRequired {
    return Intl.message(
      'User name required',
      name: 'userNameRequired',
      desc: 'User name required',
    );
  }
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: 'Password',
    );
  }
  String get passwordRequired {
    return Intl.message(
      'Password required',
      name: 'passwordRequired',
      desc: 'Password required',
    );
  }
  String get userNameOrPasswordWrong {
    return Intl.message(
      'User name or password wrong',
      name: 'userNameOrPasswordWrong',
      desc: 'User name or password wrong',
    );
  }
  String get auto {
    return Intl.message(
      'Auto',
      name: 'auto',
      desc: 'Auto',
    );
  }
  String get message {
    return Intl.message(
      'Message',
      name: 'message',
      desc: 'Message',
    );
  }

  String get personal {
    return Intl.message(
      'Personal',
      name: 'personal',
      desc: 'Personal',
    );
  }

  String get discovery {
    return Intl.message(
      'Discovery',
      name: 'discovery',
      desc: 'Discovery',
    );
  }

  String get contacts {
    return Intl.message(
      'Contacts',
      name: 'contacts',
      desc: 'Contacts',
    );
  }







}

//Locale代理类
class GmLocalizationsDelegate
    extends LocalizationsDelegate<GmLocalizations> {
  const GmLocalizationsDelegate();

  //是否支持某个Local
  @override
  bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);

  // Flutter会调用此类加载相应的Locale资源类
  @override
  Future<GmLocalizations> load(Locale locale) {
    //3
    return GmLocalizations.load(locale);
  }

  // 当Localizations Widget重新build时，是否调用load重新加载Locale资源.
  @override
  bool shouldReload(GmLocalizationsDelegate old) => false;
}
