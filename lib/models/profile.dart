import 'package:json_annotation/json_annotation.dart';
import "user.dart";
import "cacheConfig.dart";
part 'profile.g.dart';

@JsonSerializable()
class Profile {
    Profile();

    User user;
    String token;
    int theme;
    int themeDark;
    CacheConfig cache;
    String lastLogin;
    String locale;
    // 1 light 2 dark
    int themeMode;
    List themesDay;
    List themesDark;
    List themesDayMessage;
    List themesDarkMessage;
    List themesDayBg;
    List themesDarkBg;
    
    factory Profile.fromJson(Map<String,dynamic> json) => _$ProfileFromJson(json);
    Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
