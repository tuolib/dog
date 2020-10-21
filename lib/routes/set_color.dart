import '../index.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/services.dart';


bool setType = false;
class SegmentedControlExample extends StatefulWidget {
  // 1 修改 2 新增
  final int type;

  SegmentedControlExample({
    Key key,
    this.type,
  }) : super(key: key);

  @override
  State createState() => SegmentedControlExampleState();
}

class SegmentedControlExampleState extends State<SegmentedControlExample> {
  ThemeModel themeObj;
  int _segmented = 0;
  final Map<int, Widget> myTabs = const <int, Widget>{
    0: Text(
      "Accent",
      style: TextStyle(
        fontSize: 14,
      ),
    ),
    1: Text(
      "Background",
      style: TextStyle(
        fontSize: 14,
      ),
    ),
    2: Text(
      "Messages",
      style: TextStyle(
        fontSize: 14,
      ),
    ),
  };
  TextEditingController _textController = TextEditingController();
  FocusNode focusNode1 = FocusNode();

  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  Color accentColorBack;
  Color backgroundColorBack;
  Color messagesColorBack;

  Color accentColor;
  Color backgroundColor;
  Color messagesColor;

  @override
  void initState() {
    super.initState();
    // if (widget.type == 2 && setType == false) {
    //   if (themeObj.themeMode == 1) {
    //     oldTheme = themeObj.theme;
    //     themeObj.theme = 0;
    //   } else if (themeObj.themeMode == 2) {
    //     oldThemeDark = themeObj.theme;
    //     themeObj.themeDark = 0;
    //   }
    // }
  }

  @override
  void dispose() {
    super.dispose();
    if (accentColorBack != null) {
      themeObj.themeColorValue(accentColorBack.value, 0);
    }
    if (backgroundColorBack != null) {
      themeObj.themeColorValue(backgroundColorBack.value, 1);
    }
    if (messagesColorBack != null) {
      themeObj.themeColorValue(messagesColorBack.value, 2);
    }
    _textController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    themeObj = Provider.of<ThemeModel>(context);
    // accentColor = themeObj.primaryColor;
    // backgroundColor = themeObj.scaffoldBackgroundColor;
    // messagesColor = themeObj.messagesColor;
    if (accentColor == null) {
      accentColor = themeObj.primaryColor;
    }
    if (backgroundColor == null) {
      backgroundColor = themeObj.scaffoldBackgroundColor;
    }
    if (messagesColor == null) {
      messagesColor = themeObj.messagesColor;
    }
    // if (accentColorBack == null) {
    //   accentColorBack = accentColor;
    // }
    // if (backgroundColorBack == null) {
    //   backgroundColorBack = backgroundColor;
    // }
    // if (messagesColorBack == null) {
    //   messagesColorBack = messagesColor;
    // }
    if (_segmented == 0) {
      pickerColor = accentColor;
      _textController.text = "${accentColor.toHex().substring(3)}";
    } else if (_segmented == 1) {
      pickerColor = backgroundColor;
      _textController.text = "${backgroundColor.toHex().substring(3)}";
    } else if (_segmented == 2) {
      pickerColor = messagesColor;
      _textController.text = "${messagesColor.toHex().substring(3)}";
    }
    return GestureDetector(
      onTap: () {
        focusNode1.unfocus();
      },
      child: CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        // resizeToAvoidBottomPadding: false,
        backgroundColor: themeObj.barBackgroundColor,
        child: SafeArea(
          // top: false,
          // left: false,
          // right: false,
          child: Container(
            // width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: themeObj.barBackgroundColor,
                    border: Border(
                      bottom: BorderSide(
                        color: themeObj.borderColor,
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                  // margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CupertinoSlidingSegmentedControl<int>(
                        // backgroundColor: themeObj.inputBackgroundColor,
                        padding: EdgeInsets.all(0),
                        groupValue: _segmented,
                        children: myTabs,
                        onValueChanged: (i) {
                          // logger.d(i);
                          setState(() {
                            _segmented = i;
                          });
                        },
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      children: [Text('message')],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: themeObj.barBackgroundColor,
                    border: Border(
                      bottom: BorderSide(
                        color: themeObj.borderColor,
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                      top: BorderSide(
                        color: themeObj.borderColor,
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                  padding:
                      EdgeInsets.only(top: 6, bottom: 6, left: 8, right: 8),
                  child: Stack(
                    children: [
                      Container(
                        height: 30,
                        child: CupertinoTextField(
                          inputFormatters: [
                            // WhitelistingTextInputFormatter.digitsOnly,
                            //RegExp("[a-zA-Z0-9]")
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-zA-Z0-9]"),
                            ),
                            LengthLimitingTextInputFormatter(6),
                            // WhitelistingTextInputFormatter.,
                          ],
                          onSubmitted: (str) {
                            logger.d(str.length);
                            if (str.length != 6) {
                              _resetColor();
                            } else {
                              changeColor(HexColor.fromHex("#ff$str"));
                            }
                            // logger.d(123);
                          },
                          textInputAction: TextInputAction.done,
                          padding: EdgeInsets.only(
                              left: 40, right: 10, top: 6, bottom: 6),
                          // expands: true,
                          controller: _textController,
                          focusNode: focusNode1,
                          placeholder: '',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: themeObj.normalColor,
                          ),
                          decoration: BoxDecoration(
                            color: themeObj.inputBackgroundColor,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              width: 1,
                              color: themeObj.borderColor,
                            ),
                          ),
                          maxLines: 1,
                          onChanged: _inputTextChange,
                        ),
                      ),
                      Positioned(
                        left: 30,
                        top: 6,
                        child: Container(
                          child: Text(
                            '#',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 6,
                        top: 5,
                        child: Container(
                          width: 20.0,
                          height: 20.0,
                          decoration: BoxDecoration(
                            color: pickerColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Material(
                    child: ColorPicker(
                      pickerColor: pickerColor,
                      onColorChanged: changeColor,
                      showLabel: false,
                      colorPickerWidth: MediaQuery.of(context).size.width,
                      pickerAreaHeightPercent: 0.4,
                      enableAlpha: false,
                      displayThumbColor: true,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: themeObj.barBackgroundColor,
                    border: Border(
                      top: BorderSide(
                        color: themeObj.borderColor,
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                  height: 60,
                  child: Flex(
                    direction: Axis.horizontal,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            // logger.d(1);
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: themeObj.barBackgroundColor,
                              border: Border(
                                right: BorderSide(
                                  color: themeObj.borderColor,
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: themeObj.normalColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            _saveColor();
                          },
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: themeObj.barBackgroundColor,
                            ),
                            child: Center(
                              child: Text(
                                'Set',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: themeObj.normalColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _inputTextChange(String text) {
    if (text.length == 6) {
      changeColor(HexColor.fromHex("#ff$text"));
    }
    // if (text.length > 0) {
    //   setState(() {
    //     showSend = true;
    //   });
    // } else {
    //   setState(() {
    //     showSend = false;
    //   });
    // }

  }

  _resetColor() {
    changeColor(pickerColor);
  }
  // ValueChanged<Color> callback
  void changeColor(Color color) {
    // logger.d()
    logger.d(color.toHex());
    // themeObj.themeColorValue(color.value, _segmented);
    // logger.d(Global.profile.getProperty(''));
    setState(() {

      if (_segmented == 0) {
        // themeObj.theme = 1;
        accentColor = color;
        pickerColor = accentColor;
        // _textController.text = "${accentColor.toHex().substring(3)}";
      } else if (_segmented == 1) {
        backgroundColor = color;
        pickerColor = backgroundColor;
        // _textController.text = "${backgroundColor.toHex().substring(3)}";
      } else if (_segmented == 2) {
        messagesColor = color;
        pickerColor = messagesColor;
        // _textController.text = "${messagesColor.toHex().substring(3)}";
      }
      pickerColor = color;
      _textController.text = '${color.toHex().substring(3)}';
    });
  }

  _saveColor() {
    if (widget.type == 1) {

    } else if (widget.type == 2) {
      themeObj.themeColorAdd(accentColor.value, 0);
      themeObj.themeColorAdd(backgroundColor.value, 1);
      themeObj.themeColorAdd(messagesColor.value, 2);
    }
    Navigator.of(context).pop();
  }
}
