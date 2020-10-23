import 'package:json_annotation/json_annotation.dart';
import "user.dart";
import "cacheConfig.dart";
part 'profile.g.dart';

@JsonSerializable()
class Profile {
    Profile();

    User user;
    String token;
    //Day 颜色序号 在数组中的下标
    int theme;
    //Dark 颜色序号 在数组中的下标
    int themeDark;
    CacheConfig cache;
    String lastLogin;
    String locale;
    // 1 day 2 dark
    int themeMode;
    // primary 颜色
    List themesDay;
    List themesDark;
    // 自己发的消息背景
    List themesDayMessage;
    List themesDarkMessage;
    // 聊天对话页面背景
    List themesDayBg;
    List themesDarkBg;


    // 聊天对话页面背景 渐变色
    List themesDayBg2;
    List themesDarkBg2;
    
    factory Profile.fromJson(Map<String,dynamic> json) => _$ProfileFromJson(json);
    Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
