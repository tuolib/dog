import '../index.dart';

class FriendsPage extends StatefulWidget {
  @override
  _FriendsPage createState() => _FriendsPage();
}

class _FriendsPage extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends'),
      ),
      body: Container(
        child: Text('_FriendsPage'),
      ), // 构建主页面
    );
  }

}