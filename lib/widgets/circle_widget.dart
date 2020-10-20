import '../index.dart';

class CircleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeModel themeObj = Provider.of<ThemeModel>(context);
    Widget bigCircle = Container(
      width: 38.0,
      height: 38.0,
      color: themeObj.menuBackgroundColor,
      // decoration: BoxDecoration(
      //   // color: Colors.orange,
      //   color: themeObj.menuBackgroundColor,
      //   // shape: BoxShape.circle,
      // ),
    );

    return Material(
      color: DataUtil.iosBarBgColor(),
      child: Center(
        child: Stack(
          children: <Widget>[
            bigCircle,
            // 最上面
            Positioned(
              child: CircleButton(color: Global.themes[0]),
              top: 0.0,
              left: 15.0,
            ),
            Positioned(
              child: CircleButton(color: Global.themes[1]),
              top: 8.0,
              left: 2.0,
            ),
            Positioned(
              child: CircleButton(color: Global.themes[2]),
              bottom: 8.0,
              left: 2.0,
            ),
            Positioned(
              child: CircleButton(color: Global.themes[3]),
              top: 8.0,
              right: 2.0,
            ),
            Positioned(
              child: CircleButton(color: Global.themes[4]),
              bottom: 8.0,
              right: 2.0,
            ),
            // 最底下
            Positioned(
              child: CircleButton(color: Global.themes[5]),
              bottom: 0.0,
              right: 15.0,
            ),
            // 中间
            Positioned(
              child: CircleButton(color: Global.themes[6]),
              top: 15.0,
              left: 15.0,
            ),
          ],
        ),
      ),
    );
  }
}

class CircleButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final IconData iconData;
  final int color;

  const CircleButton({
    Key key,
    this.onTap,
    this.iconData,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = 8.0;

    return InkResponse(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Color(color),
          shape: BoxShape.circle,
        ),
        // child: Icon(
        //   iconData,
        //   color: color,
        // ),
      ),
    );
  }
}
