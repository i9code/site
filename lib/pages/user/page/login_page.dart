import 'package:flutter/material.dart';
import 'package:swiftclub/components/components.dart';
import 'package:swiftclub/kit/kit.dart';
import 'package:swiftclub/event/event.dart';
import 'package:swiftclub/network/network.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwdController = TextEditingController();

  TextEditingController _regEmailController = TextEditingController();
  TextEditingController _regPwdController = TextEditingController();
  TextEditingController _regPwdTwiceController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ProgressHud(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          child: HeaderView(),
          preferredSize: Size.fromHeight(50),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildLoginBody() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[100], borderRadius: BorderRadius.circular(16)),
        padding: EdgeInsets.fromLTRB(30, 40, 30, 40),
        width: ResponsiveWidget.isSmallScreen(context)
            ? 300
            : MediaQuery.of(context).size.width * 400 / 1024.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Text(
                '登  录',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            TextField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: InputDecoration(
                    hintText: '请输入邮箱',
                    labelText: '邮箱',
                    prefixIcon: Icon(Icons.email),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[300])))),
            TextField(
              keyboardType: TextInputType.text,
              obscureText: true,
              controller: _passwdController,
              decoration: InputDecoration(
                  hintText: '请输入密码',
                  labelText: '密码',
                  prefixIcon: Icon(Icons.lock),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[300]))),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Builder(builder: (context) {
                    return FlatButton(
                      padding: EdgeInsets.only(
                          left:
                              ResponsiveWidget.isLargeScreen(context) ? 50 : 10,
                          right: ResponsiveWidget.isLargeScreen(context)
                              ? 50
                              : 10),
                      onPressed: () {
                        _signIn(context).then((success) {
                          Navigator.of(this.context).pop();
                        });
                      },
                      child: Text('登 录'),
                      color: Colors.indigoAccent,
                      textColor: Colors.white,
                    );
                  }),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: FlatButton(
                    padding: EdgeInsets.only(
                        left: ResponsiveWidget.isLargeScreen(context) ? 50 : 10,
                        right:
                            ResponsiveWidget.isLargeScreen(context) ? 50 : 10),
                    onPressed: () {
                      setState(() {
                        isLogin = false;
                      });
                    },
                    child: Text('注 册'),
                    color: Colors.black87,
                    textColor: Colors.white,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<bool> _signIn(BuildContext context) async {
    String passwd = _passwdController.text;
    String email = _emailController.text;
    if ((passwd.isNotEmpty) && (email.isNotEmpty)) {
      final response = await Network.userLogin(passwd: passwd, email: email);
      final status = SafeValue.toInt(response['status']);
      final message = SafeValue.toStr(response['message']);
      if (status == 0) {
        DataHelper.setToken(SafeValue.toMap(response['data']));
        final userInfoRes = await Network.getAccountInfo();
        final ustatus = SafeValue.toInt(userInfoRes['status']);
        final umessage = SafeValue.toStr(userInfoRes['message']);
        if (ustatus == 0) {
          HudUtil.showSucceedHud(context, text: '登录成功');
          DataHelper.setUser(SafeValue.toMap(userInfoRes['data']));
          eventBus.fire(UserLoginStateChangeEvent(login: true));
          return Future.value(true);
        } else {
          HudUtil.showErrorHud(context, text: umessage);
          return Future.value(false);
        }
      } else {
        // 登入失败
        HudUtil.showErrorHud(context, text: message);
        return Future.value(false);
      }
    } else {
      HudUtil.showErrorHud(context, text: '信息不完整');
      return Future.value(false);
    }
  }

  _register() async {}

  Widget _buildRegister() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[100], borderRadius: BorderRadius.circular(16)),
        padding: EdgeInsets.fromLTRB(30, 40, 30, 40),
        width: MediaQuery.of(context).size.width * 400 / 1024.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Text(
                '注  册',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            TextField(
                keyboardType: TextInputType.emailAddress,
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: '请输入昵称',
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[300])))),
            TextField(
                keyboardType: TextInputType.emailAddress,
                controller: _regEmailController,
                decoration: InputDecoration(
                    labelText: '请输入邮箱',
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[300])))),
            TextField(
              keyboardType: TextInputType.text,
              obscureText: true,
              controller: _regPwdController,
              decoration: InputDecoration(
                  labelText: '请输入密码',
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[300]))),
            ),
            TextField(
              keyboardType: TextInputType.text,
              obscureText: true,
              controller: _regPwdTwiceController,
              decoration: InputDecoration(
                  labelText: '请重复输入密码',
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[300]))),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: FlatButton(
                    padding: EdgeInsets.only(
                        left: ResponsiveWidget.isLargeScreen(context) ? 50 : 10,
                        right:
                            ResponsiveWidget.isLargeScreen(context) ? 50 : 10),
                    onPressed: _register,
                    child: Text('注 ��'),
                    color: Colors.indigoAccent,
                    textColor: Colors.white,
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 20),
                    child: FlatButton(
                      padding: EdgeInsets.only(
                          left:
                              ResponsiveWidget.isLargeScreen(context) ? 50 : 10,
                          right: ResponsiveWidget.isLargeScreen(context)
                              ? 50
                              : 10),
                      onPressed: () {
                        setState(() {
                          isLogin = true;
                        });
                      },
                      child: Text('登 录'),
                      color: Colors.black87,
                      textColor: Colors.white,
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return isLogin ? _buildLoginBody() : _buildRegister();
  }
}
