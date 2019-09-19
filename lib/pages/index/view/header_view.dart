import 'package:flutter/material.dart';
import 'package:swiftclub/event/event.dart';
import 'package:swiftclub/kit/value/safe_value.dart';
import 'package:swiftclub/kit/data/data_helper.dart';
import 'package:swiftclub/components/popup_menu/popup_menu.dart';

class IndexHeaderView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IndexHeaderViewState();
  }
}

class _IndexHeaderViewState extends State<IndexHeaderView> {
  bool isLogin;

  GlobalKey btnKey = GlobalKey();

  @override
  void initState() {
    isLogin = DataHelper.userIsLogin();
    super.initState();
    eventBus.on<UserLoginStateChangeEvent>().listen((event) {
      setState(() {
        isLogin = event.login;
      });
    });
  }

  void onClickMenu(MenuItemProvider item) {
    String menuTitle = item.menuTitle;
    print(menuTitle);
    if (menuTitle == '写作') {
      _writeTopic();
    } else if (menuTitle == '退出') {
      _lougout();
    } else if (menuTitle == '写书') {
      _writeBooklet();
    }
  }

  void onDismiss() {
    print('Menu is dismiss');
  }

  @override
  Widget build(BuildContext context) {
    PopupMenu.context = context;
    return _buildHeader();
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(bottom: 30),
      margin: EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
          color: Color(0xffF9F9FA),
          border: Border(top: BorderSide(color: Color(0xffF05138), width: 5))),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              isLogin ? _loginStateWidget() : _normalStateWidget(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Image.asset('images/swift_logo.png'),
                width: 100,
                height: 100,
              ),
              Container(
                margin: EdgeInsets.only(left: 20),
                width: MediaQuery.of(context).size.width * 640 / 1024.0,
                child: Text(
                  'Swift是一种支持多编程范式和编译式的编程语言，是用来撰写macOS/OS X、iOS、watchOS和tvOS的语言之一。 收录Swift频道最新文章和资讯。',
                  style: TextStyle(
                    height: 1.5,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
    );
  }

  Widget _loginStateWidget() {
    Map userInfo = DataHelper.user();
    return GestureDetector(
      key: btnKey,
      onTap: _loginShowMenu,
      child: Container(
        height: 50,
        width: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Color(0xffF05138),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20))),
        child: Container(
          width: 26,
          height: 26,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(13)),
          child: Image.network(
            SafeValue.toStr(userInfo['avator']),
            width: 20,
            height: 20,
          ),
        ),
      ),
    );
  }

  _loginShowMenu() {
    // 弹气泡
    final menu = PopupMenu(items: [
      MenuItem(
          title: '写作', textStyle: TextStyle(fontSize: 14, color: Colors.white)),
      MenuItem(
          title: '写书', textStyle: TextStyle(fontSize: 14, color: Colors.white)),
      MenuItem(
          title: '退出', textStyle: TextStyle(fontSize: 14, color: Colors.white)),
    ], onClickMenu: onClickMenu, onDismiss: onDismiss, maxColumn: 1);
    menu.show(widgetKey: btnKey);
  }

  Widget _normalStateWidget() {
    return GestureDetector(
      onTap: _sigin,
      child: Container(
        height: 50,
        width: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Color(0xffF05138),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20))),
        child: Text(
          'S',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }

  _sigin() {
    Navigator.pushNamed(context, '/login');
  }

  _lougout() {
    DataHelper.clearLoginInfo();
    eventBus.fire(UserLoginStateChangeEvent(login: false));
  }

  _writeTopic() {
    Navigator.of(context).pushNamed('/topicAdd');
  }

  _writeBooklet() {
    Navigator.of(context).pushNamed('/booklet');
  }
}
