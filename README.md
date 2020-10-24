### build

```shell

flutter build apk --release

```





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

## appearance
### 白色主题

- 固定颜色
红色 ： 退出按钮 退出其他登录设备 删除行为，tab栏新消息数量圆圈背景

- 按钮
操作按钮无背景，按钮主颜色
操作按钮有背景（背景主颜色，按钮白色）
返回箭头按钮 主颜色
前进箭头按钮 灰色
取消按钮 主颜色

- 主页 tab 栏
选中颜色，主颜色

- online ，主颜色

- 勾选中 颜色，主颜色

- 已读未读标志 主颜色

- 拨打电话 已接通主颜色 未接通红色

- 链接 主颜色

- 被回复的引用线和人名字，主颜色

- 发消息人名字，头像背景生成的颜色

- 聊天消息
对方背景颜色 白色
对方文字颜色 黑色

自己背景颜色， 主颜色
自己文字颜色， 黑色/白色

file对方背景灰色
file圆圈 主颜色
file 图标 白色

- 列表，title，文字颜色 黑色，灰色

- 总体背景色 灰色
- tab栏背景色 灰色
- 列表背景色 白色

### 暗色主题

- 总体背景色 黑色
- tab栏背景色 浅黑
- 列表背景色 浅黑
- chats contact 列表黑色
- 总体文字 白色 ，浅白色

- 聊天消息
对方背景颜色 浅灰色
对方文字颜色 白色

自己背景颜色， 主颜色
自己文字颜色， 白色






