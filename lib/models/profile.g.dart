// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return Profile()
    ..user = json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>)
    ..token = json['token'] as String
    ..theme = json['theme'] as int
    ..themeMode = json['themeMode'] as int
    ..themeDark = json['themeMode'] as int
    // ..themesDay = json['themesDay'] as List
    // ..themesDark = json['themesDark'] as List
    // ..themesDayMessage = json['themesDayMessage'] as List
    // ..themesDarkMessage = json['themesDarkMessage'] as List
    // ..themesDayBg = json['themesDayBg'] as List
    // ..themesDarkBg = json['themesDarkBg'] as List
    // ..themesDayBg2 = json['themesDayBg2'] as List
    // ..themesDarkBg2 = json['themesDarkBg2'] as List
    ..dayList = json['dayList'] as List
    ..darkList = json['darkList'] as List
    ..cache = json['cache'] == null
        ? null
        : CacheConfig.fromJson(json['cache'] as Map<String, dynamic>)
    ..lastLogin = json['lastLogin'] as String
    ..locale = json['locale'] as String;
}

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'user': instance.user,
      'token': instance.token,
      'theme': instance.theme,
      'themeDark': instance.themeDark,
      'themeMode': instance.themeMode,
      // 'themesDay': instance.themesDay,
      // 'themesDark': instance.themesDark,
      // 'themesDayMessage': instance.themesDayMessage,
      // 'themesDarkMessage': instance.themesDarkMessage,
      // 'themesDayBg': instance.themesDayBg,
      // 'themesDarkBg': instance.themesDarkBg,
      // 'themesDayBg2': instance.themesDayBg2,
      // 'themesDarkBg2': instance.themesDarkBg2,
      'dayList': instance.dayList,
      'darkList': instance.darkList,
      'cache': instance.cache,
      'lastLogin': instance.lastLogin,
      'locale': instance.locale
    };
