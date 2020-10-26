import 'package:flutter/rendering.dart';

import '../index.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:worm_indicator/worm_indicator.dart';

abstract class KeyboardHiderMixin {
  void hideKeyboard({
    BuildContext context,
    bool hideTextInput = true,
    bool requestFocusNode = true,
  }) {
    if (hideTextInput) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }
    if (context != null && requestFocusNode) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }
}

bool setType = false;

class SetColorWidget extends StatefulWidget {
  // 1 修改 2 新增
  final int type;

  SetColorWidget({
    Key key,
    this.type,
  }) : super(key: key);

  @override
  State createState() => _SetColorWidgetState();
}

class _SetColorWidgetState extends State<SetColorWidget> {
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
  TextEditingController _textController2 = TextEditingController();
  FocusNode focusNode2 = FocusNode();

  Color pickerColor = Color(0xff443a49);
  Color pickerColor2;
  int selectPicker = 1;

  Color accentColor;
  Color backgroundColor;
  Color backgroundColor2;
  Color messagesColor;
  Color messagesColor2;

  int backgroundColorTab = 0;

  final controller = PageController(viewportFraction: 1);

  ScrollController _sliverController = ScrollController();

  int pageNum = 1;

  double inputFontSize = 16;
  double inputPaddingTop = 5;
  double inputBorder = 1;
  double inputHeight = 30;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
    // if (accentColorBack == null) {
    //   accentColorBack = accentColor;
    // }
    // if (backgroundColorBack == null) {
    //   backgroundColorBack = backgroundColor;
    // }
    // if (messagesColorBack == null) {
    //   messagesColorBack = messagesColor;
    // }
    // logger.d(Global.themes[themeObj.theme]);
    if (accentColor == null) {
      accentColor = themeObj.primaryColor;
    }
    if (backgroundColor == null) {
      backgroundColor = themeObj.messagesChatBg;
    }
    if (backgroundColor2 == null) {
      if (themeObj.messagesChatBg2 != null) {
        backgroundColor2 = themeObj.messagesChatBg2;
      }
    }
    if (messagesColor == null) {
      messagesColor = themeObj.messagesColor;
    }
    if (messagesColor2 == null) {
      if (themeObj.messagesColor2 != null) {
        messagesColor2 = themeObj.messagesColor2;
      }
      // messagesColor2 = themeObj.messagesColor2;
    }
    if (_segmented == 0) {
      pickerColor = accentColor;
      _textController.text = "${accentColor.toHex().substring(3)}";
    } else if (_segmented == 1) {
      pickerColor = backgroundColor;
      logger.d('${backgroundColor.toHex()}');
      _textController.text = "${backgroundColor.toHex().substring(3)}";
      if (backgroundColor2 != null) {
        pickerColor2 = backgroundColor2;
        _textController2.text = "${backgroundColor2.toHex().substring(3)}";
      }
      // if (selectPicker == 0) {
      //   pickerColor = backgroundColor;
      //   logger.d('${backgroundColor.toHex()}');
      //   _textController.text = "${backgroundColor.toHex().substring(3)}";
      // } else {
      //   pickerColor = backgroundColor2;
      //   logger.d('${backgroundColor2.toHex()}');
      //   _textController.text = "${backgroundColor2.toHex().substring(3)}";
      // }
    } else if (_segmented == 2) {
      pickerColor = messagesColor;
      _textController.text = "${messagesColor.toHex().substring(3)}";
      if (messagesColor2 != null) {
        pickerColor2 = messagesColor2;
        _textController2.text = "${messagesColor2.toHex().substring(3)}";
      }
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
                _buildTab(),
                Expanded(
                  flex: 1,
                  child: _messagesWidget(),
                ),
                _buildInput(),
                Container(
                  child: Material(
                    child: ColorPicker(
                      pickerColor: _pickerSelectColor(),
                      onColorChanged: changeColor,
                      showLabel: false,
                      colorPickerWidth: MediaQuery.of(context).size.width,
                      pickerAreaHeightPercent: 0.4,
                      enableAlpha: false,
                      displayThumbColor: true,
                    ),
                  ),
                ),
                _buildButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton() {
    return Container(
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
    );
  }

  Widget _buildTab() {
    return Container(
      // width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: 10,
        right: 10,
      ),
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
      child: Flex(
        // mainAxisAlignment: MainAxisAlignment.center,
        // mainAxisSize: MainAxisSize.max,
        direction: Axis.horizontal,
        children: [
          Expanded(
            flex: 1,
            child: CupertinoSlidingSegmentedControl<int>(
              // backgroundColor: themeObj.inputBackgroundColor,
              // padding: EdgeInsets.all(0),
              groupValue: _segmented,
              children: myTabs,
              onValueChanged: (i) {
                // logger.d(i);
                setState(() {
                  selectPicker = 1;
                  focusNode1.unfocus();
                  focusNode2.unfocus();
                  if (i == 0) {
                    pickerColor = accentColor;
                    pickerColor2 = null;
                  } else if (i == 1) {
                    pickerColor = backgroundColor;
                    pickerColor2 = backgroundColor2;
                  } else if (i == 2) {
                    pickerColor = messagesColor;
                    pickerColor2 = messagesColor2;
                  }
                  _segmented = i;
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      height: 48,
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
      padding: EdgeInsets.only(
        top: 6,
        bottom: 6,
        left: 8,
        right: 8,
      ),
      child: _inputBox(),
    );
  }

  Widget _inputBox() {
    return Stack(
      children: [
        Container(
          height: 36,
          child: Flex(
            direction: Axis.horizontal,
            mainAxisSize: MainAxisSize.max,
            children: [
              _colorInput(1),
              if (_segmented != 0) _colorInput(2),
            ],
          ),
        ),
      ],
    );
  }

  Widget _colorInput(int type) {
    if (type == 1) {
      return Expanded(
        flex: 1,
        child: Stack(
          children: [
            Container(
              height: inputHeight,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(15),
              //   border: Border.all(
              //     color:
              //         selectPicker == 1 ? Colors.green : themeObj.borderColor,
              //     width: selectPicker == 1 ? 2 : 1,
              //   ),
              // ),
              child: Focus(
                child: CupertinoTextField(
                  expands: true,
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
                    left: 40,
                    right: 10,
                    top: inputPaddingTop,
                    bottom: inputPaddingTop,
                  ),
                  // expands: true,
                  controller: _textController,
                  focusNode: focusNode1,
                  placeholder: '',
                  style: TextStyle(
                    fontSize: inputFontSize,
                    // color: themeObj.normalColor,
                    // fontSize: selectPicker == 1 ? 18 : 14.0,
                    color:
                        selectPicker == 1 ? Colors.green : themeObj.normalColor,
                  ),
                  decoration: BoxDecoration(
                    color: themeObj.inputBackgroundColor,
                    borderRadius: BorderRadius.circular(inputHeight / 2),
                    border: Border.all(
                      width: inputBorder,
                      color: themeObj.borderColor,
                    ),
                  ),
                  // maxLines: 1,
                  maxLines: null,
                  minLines: null,
                  onChanged: _inputTextChange,
                ),
                onFocusChange: (hasFocus) {
                  if (hasFocus) {
                    if (selectPicker == 2) {
                      focusNode1.unfocus();
                    }
                    setState(() {
                      selectPicker = 1;
                      changeColor(pickerColor, type: 1);
                      // isTextFiledFocus = hasFocus;
                    });
                  }
                },
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: pickerColor2 != null ? _closeIcon(1) : SizedBox(),
            ),
            Positioned(
              left: 30,
              top: 0,
              child: _colorPre(),
            ),
            Positioned(
              left: 6,
              top: 0,
              child: _colorCircle(1),
            ),
          ],
        ),
      );
    } else {
      return Expanded(
        flex: pickerColor2 != null ? 1 : null,
        child: pickerColor2 != null
            ? Container(
                margin: EdgeInsets.only(left: 10),
                child: Stack(
                  children: [
                    Container(
                      height: inputHeight,
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(15),
                      //   border: Border.all(
                      //     color: themeObj.borderColor,
                      //     width: 1,
                      //   ),
                      // ),
                      child: Focus(
                        child: CupertinoTextField(
                          expands: true,
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
                            left: 40,
                            right: 10,
                            top: inputPaddingTop,
                            bottom: inputPaddingTop,
                          ),
                          // expands: true,
                          controller: _textController2,
                          focusNode: focusNode2,
                          placeholder: '',
                          style: TextStyle(
                            fontSize: inputFontSize,
                            // color: themeObj.normalColor,
                            // fontSize: selectPicker == 2 ? 18 : 14.0,
                            color: selectPicker == 2
                                ? Colors.green
                                : themeObj.normalColor,
                          ),
                          decoration: BoxDecoration(
                            color: themeObj.inputBackgroundColor,
                            borderRadius:
                                BorderRadius.circular(inputHeight / 2),
                            border: Border.all(
                              width: inputBorder,
                              color: themeObj.borderColor,
                            ),
                          ),
                          maxLines: null,
                          minLines: null,
                          onChanged: _inputTextChange,
                        ),
                        onFocusChange: (hasFocus) {
                          if (hasFocus) {
                            if (selectPicker == 1) {
                              focusNode2.unfocus();
                            }
                            if (pickerColor2 != null) {
                              setState(() {
                                selectPicker = 2;
                                changeColor(pickerColor2, type: 2);
                                // isTextFiledFocus = hasFocus;
                              });
                            }
                          }
                        },
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: _closeIcon(2),
                    ),
                    Positioned(
                      left: 30,
                      top: 0,
                      child: _colorPre(),
                    ),
                    Positioned(
                      left: 6,
                      top: 0,
                      child: _colorCircle(2),
                    ),
                  ],
                ),
              )
            : _addIcon(),
      );
    }
  }

  Widget _colorPre() {
    return Container(
      height: 30,
      alignment: Alignment.center,
      child: Text(
        '#',
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _colorText() {
    return Container(
      height: 30,
      alignment: Alignment.center,
      child: Opacity(
        opacity: 1,
        child: Container(
          height: inputHeight,
          decoration: BoxDecoration(
            color: themeObj.barBackgroundColor,
          ),
          child: Text(
            '${_textController.text}',
            style: TextStyle(
              fontSize: inputFontSize,
            ),
          ),
        ),
      ),
    );
  }

  Widget _colorCircle(int type) {
    return Container(
      height: 30,
      width: 20,
      alignment: Alignment.center,
      child: Container(
        width: 20.0,
        height: 20.0,
        decoration: BoxDecoration(
          // border: Border.all(),
          color: type == 1 ? pickerColor : pickerColor2,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _closeIcon(int type) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 30,
        width: 46,
        alignment: Alignment.center,
        child: Icon(
          Icons.clear,
          color: themeObj.inactiveColor,
        ),
      ),
      onTap: () {
        setState(() {
          // if (selectPicker == )

          selectPicker = 1;
          if (type == 1) {
            // pickerColor = pickerColor2;
            if (_segmented == 1) {
              backgroundColor2 = null;
            } else if (_segmented == 2) {
              messagesColor2 = null;
            }
            changeColor(pickerColor2, type: 1, close: true);
          } else {
            if (_segmented == 1) {
              backgroundColor2 = null;
            } else if (_segmented == 2) {
              messagesColor2 = null;
            }
            changeColor(pickerColor, type: 1, close: true);
          }
        });
      },
    );
  }

  Widget _addIcon() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        // color: Colors.red,
        // padding: EdgeInsets.only(left: 10, right: 10),
        width: 40,
        height: 30,
        child: Icon(
          Icons.add,
          color: themeObj.inactiveColor,
        ),
      ),
      onTap: () {
        logger.d('click');
        setState(() {
          pickerColor2 = DataUtil.randomColor();
          selectPicker = 2;
          changeColor(pickerColor2, type: 2);
        });
      },
    );
  }

  Widget _exampleContent() {
    Widget back;
    // if (_segmented == 0) {
    //   pageNum = 2;
    // }
    back = Container(
      child: Stack(
        children: [
          PageView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            controller: controller,
            itemBuilder: (BuildContext context, int pos) {
              if (pos == 0) {
                return _messagesWidget();
              } else {
                return _chatList();
              }
            },
            itemCount: pageNum,
          ),
          if (pageNum > 1)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                child: SmoothPageIndicator(
                    controller: controller, // PageController
                    count: 2,
                    effect: WormEffect(), // your preferred effect
                    onDotClicked: (index) {}),
              ),
            ),
        ],
      ),
    );

    return back;
  }

  Widget _messagesWidget() {
    return SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        // mainAxisAlignment: MainAxisAlignment.center,
        reverse: true,
        scrollDirection: Axis.vertical,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                backgroundColor,
                backgroundColor2 == null ? backgroundColor : backgroundColor2,
              ],
            ),
          ),
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: _chatBubble(
                  message: 'Yes, turn to camera.',
                  time: 1601108277901,
                  isMe: false,
                  replyText:
                      'Do you have some apple xxxxxx slsdf sldfjs sdf lfsdf sdlf sdf sdfs sdf?',
                  isReply: false,
                  replyName: 'Bob Smith',
                  index: 0,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: _chatBubble(
                  message:
                      'Does he want me to turn from the right or turn form the left?',
                  time: 1601108277901,
                  isMe: true,
                  isReply: false,
                  index: 1,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: _chatBubble(
                  message: 'Right side. And, uh, with intensity.',
                  time: 1601108277901,
                  isMe: false,
                  replyText: 'Does he want me to turn from the',
                  isReply: true,
                  replyName: 'Bob Smith',
                  index: 2,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: _chatBubble(
                  message:
                      'Is that everything? It seemed like he said quite a bit more than that.',
                  time: 1601108277901,
                  isMe: true,
                  replyText:
                      'Do you have some apple xxxxxx slsdf sldfjs sdf lfsdf sdlf sdf sdfs sdf?',
                  isReply: false,
                  replyName: 'Bob Smith',
                  index: 3,
                ),
              ),
              Container(
                // height: 30,
                width: MediaQuery.of(context).size.width,
                child: _chatBubble(
                  message: 'Do you know what time it is?',
                  time: 1601108277901,
                  isMe: false,
                  replyText:
                      'Do you have some apple xxxxxx slsdf sldfjs sdf lfsdf sdlf sdf sdfs sdf?',
                  isReply: true,
                  replyName: 'Bob Smith',
                  index: 4,
                ),
              ),
              Container(
                // height: 30,
                width: MediaQuery.of(context).size.width,
                child: _chatBubble(
                  message: "It's morning in Tokyo....",
                  time: 1601108277901,
                  isMe: true,
                  replyText: '',
                  isReply: false,
                  replyName: '',
                  index: 5,
                ),
              ),
              Container(
                height: 5,
              ),
            ],
          ),
        ));
  }

  Widget _chatBubble({
    bool isMe,
    bool isReply,
    String replyName,
    String replyText,
    String message,
    int time,
    int index,
  }) {
    // themeObj = Provider.of<ThemeModel>(context);
    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    Color paintColor = isMe ? messagesColor : themeObj.messagesColorSide;
    var alignCorner = isMe ? Alignment.topRight : Alignment.bottomLeft;
    double _radius = themeObj.radius == null ? 16 : themeObj.radius;
    Color startColor = messagesColor;
    Color endColor = messagesColor2;
    Color lastStartValue;
    Color lastEndValue;
    if (endColor != null) {
      lastStartValue = Color.lerp(startColor, endColor, index / 6);
      lastEndValue = Color.lerp(startColor, endColor, (index + 1) / 6);
      if (isMe) {
        paintColor = lastEndValue;
      }
    } else {
      lastStartValue = startColor;
      lastEndValue = startColor;
    }
    if (!isMe) {
      lastStartValue = paintColor;
      lastEndValue = paintColor;
    }
    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        Row(
//          crossAxisAlignment: align,
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(top: 2, bottom: 2, left: 2, right: 2),
              child: CustomPaint(
                painter: ChatCustomCorner(
                  color: paintColor,
                  alignment: alignCorner,
                  showCorner: false,
                  radius: _radius,
                  topColor: lastStartValue,
                  bottomColor: lastEndValue,
                ),
                child: Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            top: 3, bottom: 3, right: 8, left: 8),
                        padding: EdgeInsets.only(
                            top: 0, bottom: 0, right: 2, left: 5),
                        decoration: BoxDecoration(
                          // color: chatBubbleColor(),
                          // color: widget.isMe
                          //     ? themeObj.messagesColor
                          //     : themeObj.messagesColorSide,
                          borderRadius: BorderRadius.circular(_radius),
                        ),
                        constraints: BoxConstraints(
                          maxWidth:
                              MediaQuery.of(context).size.width / 1.3 - 30,
                          minWidth: 20.0,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: align,
                          children: <Widget>[
                            isReply
                                ? Container(
                                    decoration: BoxDecoration(
                                      // color: chatBubbleReplyColor(),
                                      // borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      border: Border(
                                          left: BorderSide(
                                        color: accentColor,
                                        width: 2.0,
                                      )),
                                    ),
                                    // constraints: BoxConstraints(
                                    //   minHeight: 25,
                                    //   maxHeight: 100,
                                    //   minWidth: 80,
                                    // ),
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Container(
                                            child: TextOneLine(
                                              "${isMe ? "You" : replyName}",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                // fontWeight: FontWeight.bold,
                                                color: accentColor,
                                              ),
                                            ),
                                            // Text(
                                            //   widget.isMe ? "You" : widget.replyName,
                                            //   style: TextStyle(
                                            //     color: Theme.of(context).accentColor,
                                            //     fontWeight: FontWeight.bold,
                                            //     fontSize: 12,
                                            //   ),
                                            //   maxLines: 1,
                                            //   textAlign: TextAlign.left,
                                            // ),
                                            // alignment: Alignment.centerLeft,
                                          ),
                                          SizedBox(height: 2),
                                          Container(
                                            child: TextOneLine(
                                              "$replyText",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                // fontWeight: FontWeight.bold,
                                                color: isMe
                                                    ? themeObj.messagesWordSelf
                                                    : themeObj.messagesWordSide,
                                              ),
                                            ),
                                            // Text(
                                            //   widget.replyText,
                                            //   style: TextStyle(
                                            //     color: widget.isMe
                                            //         ? themeObj.messagesWordSelf
                                            //         : themeObj.messagesWordSide,
                                            //     fontSize: 10,
                                            //   ),
                                            //   maxLines: 1,
                                            // ),
                                            // alignment: Alignment.centerLeft,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : SizedBox(width: 2),
                            isReply ? SizedBox(height: 5) : SizedBox(),
                            Stack(
                              children: [
                                _buildMessage(
                                  context: context,
                                  isMe: isMe,
                                  message: message,
                                  lineColor: lastEndValue,
                                ),
                                _buildMessageTime(
                                  isMe: isMe,
                                  time: time,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
            // _buildNothing(),
          ],
        ),
      ],
    );
  }

  Widget _buildMessage({
    BuildContext context,
    String message,
    bool isMe,
    Color lineColor,
  }) {
    var contentWidget = Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$message',
            style: TextStyle(
              color:
                  isMe ? themeObj.messagesWordSelf : themeObj.messagesWordSide,
            ),
          ),
          TextSpan(
            text: '_________',
            style: TextStyle(
              color: isMe ? lineColor : themeObj.messagesColorSide,
            ),
          ),
        ],
      ),
    );
    return Container(
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
        // color: widget.isMe ? themeObj.messagesColor : themeObj.messagesColorSide,
        borderRadius: BorderRadius.circular(themeObj.radius),
      ),
      child: contentWidget,
    );
  }

  Widget _buildMessageTime({bool isMe, int time}) {
    bool sending = false;
    bool success = true;
    return Positioned(
      right: 0.0,
      bottom: -10.0,
      child: Padding(
        padding: isMe
            ? EdgeInsets.only(
                right: 10,
                bottom: 10.0,
              )
            : EdgeInsets.only(
                left: 10,
                bottom: 10.0,
              ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '${TimeUtil.formatTime(time, 1, 'HH:mm')}',
              style: TextStyle(
                color: isMe
                    ? themeObj.inactiveColorMessageSelf
                    : themeObj.inactiveColorMessage,
                fontSize: 10.0,
              ),
            ),
            if (isMe)
              sending
                  ? Container(
                      child: Icon(
                        Icons.access_time,
                        size: 10,
                        color: themeObj.messagesWordSelf,
                      ),
                      height: 10.0,
                      width: 10.0,
                    )
                  : success
                      ? Icon(
                          Icons.check,
                          color: themeObj.messagesWordSelf,
                          size: 10.0,
                        )
                      : Icon(
                          Icons.sms_failed,
                          color: Colors.red,
                          size: 10.0,
                        )
          ],
        ),
      ),
    );
  }

  callback() {}

  _chatList() {}

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
  // type 1 pickerColor, 2 pickerColor2
  void changeColor(Color color, {int type = 1, bool close = false}) {
    var conver = Provider.of<ConversationListModel>(context, listen: false);
    // logger.d()
    // logger.d(color.toHex());
    // themeObj.themeColorValue(color.value, _segmented);
    // logger.d(Global.profile.getProperty(''));
    setState(() {
      if (selectPicker == 1) {
        if (_segmented == 0) {
          accentColor = color;
        } else if (_segmented == 1) {
          backgroundColor = color;
        } else if (_segmented == 2) {
          messagesColor = color;
        }
        pickerColor = color;
        _textController.text = '${color.toHex().substring(3)}';
      } else {
        if (_segmented == 0) {
          accentColor = color;
        } else if (_segmented == 1) {
          backgroundColor2 = color;
        } else if (_segmented == 2) {
          messagesColor2 = color;
        }
        pickerColor2 = color;
        _textController2.text = '${color.toHex().substring(3)}';
      }
      if (close) {
        pickerColor2 = null;
        _textController2.text = '';
      }
    });
    Map allColor = {
      'primary': accentColor.value,
      'background': backgroundColor.value,
      'message': messagesColor.value,
      'background2': backgroundColor2 == null ? null : backgroundColor2.value,
      'message2': messagesColor2 == null ? null : messagesColor2.value,
    };
    logger.d(allColor);
    conver.noti();
  }

  _pickerSelectColor() {
    if (selectPicker == 1) {
      return pickerColor;
    } else {
      return pickerColor2;
    }
  }

  _saveColor() {
    if (widget.type == 1) {
      themeObj.themeColorValue({
        'primary': accentColor.value,
        'background': backgroundColor.value,
        'background2': backgroundColor2 == null ? null : backgroundColor2.value,
        'message': messagesColor.value,
        'message2': messagesColor2 == null ? null : messagesColor2.value,
      }, 1);
      // themeObj.themeColorValue(accentColor.value, 0);
      // themeObj.themeColorValue(backgroundColor.value, 1);
      // themeObj.themeColorValue(messagesColor.value, 2);
    } else if (widget.type == 2) {
      themeObj.themeColorAdd({
        'primary': accentColor.value,
        'background': backgroundColor.value,
        'background2': backgroundColor2 == null ? null : backgroundColor2.value,
        'message': messagesColor.value,
        'message2': messagesColor2 == null ? null : messagesColor2.value,
      }, 2);
      // themeObj.themeColorAdd(accentColor.value, 0);
      // themeObj.themeColorAdd(backgroundColor.value, 1);
      // themeObj.themeColorAdd(messagesColor.value, 2);
    }
    Navigator.of(context).pop();
  }
}
