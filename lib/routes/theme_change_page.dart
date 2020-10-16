import '../index.dart';
import 'package:flutter/cupertino.dart';

class ThemeChangeRoute extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: DataUtil.iosBarBgColor(),
        // textTheme: Theme.of(context).primaryColor,
        brightness: Brightness.light,
        shadowColor: Colors.white,
        elevation: 0,
        toolbarHeight: 48,
        titleSpacing: 0,
        bottom: PreferredSize(
          child: Container(
            color: DataUtil.iosBorderGreyShallow(),
            height: 0.5,
          ),
          preferredSize: Size.fromHeight(0.5),
        ),
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.back,
            color: DataUtil.iosLightTextBlue(),
            size: 34,
          ),
          onPressed: () {
            // Navigator.of(context).pushNamed("newMessage");
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          "${GmLocalizations.of(context).theme}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: DataUtil.iosLightTextBlack(),
            //                        fontSize: 14,
          ),
        ),
      ),
      body: ListView( //显示主题色块
        children: Global.themes.map<Widget>((e) {
          return GestureDetector(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
              child: Container(
                color: e,
                height: 40,
              ),
            ),
            onTap: () {
              //主题更新后，MaterialApp会重新build
              Provider.of<ThemeModel>(context, listen: false).theme = e;
            },
          );
        }).toList(),
      ),
    );
  }
}