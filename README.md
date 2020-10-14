
###多语言生成:
```shell
flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading  lib/l10n/localization_intl.dart l10n-arb/intl_*.arb
```

### json model 自动生成
```
dependencies:
  # Your other regular dependencies here
  json_annotation: ^2.0.0

dev_dependencies:
  # Your other dev_dependencies here
  build_runner: ^1.0.0
  json_serializable: ^2.0.0


一次性生成
flutter packages pub run build_runner build

持续生成
flutter packages pub run build_runner watch

json model 生成
flutter packages pub run json_model
```


### 修改app icon
```
flutter pub run flutter_launcher_icons:main
```

flutter_linkify
animated_splash
flappy_search_bar
flutter_tags
like_button
skeleton_text
implicitly_animated_reorderable_list
flutter_styled_toast
auto_animated
adaptive_dialog
device_simulator
clipboard
extended_text_field
nice_button
material_floating_search_bar
progressive_image
appbar_textfield
search_app_bar_page





