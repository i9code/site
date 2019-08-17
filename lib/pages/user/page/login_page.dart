import 'package:flutter_web/material.dart';
import 'package:swiftclub/components/components.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        child: HeaderView(),
        preferredSize: Size.fromHeight(50),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildLoginBody() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[100], borderRadius: BorderRadius.circular(16)),
        padding: EdgeInsets.fromLTRB(30, 40, 30, 40),
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Text(
                '登  录',
                style: TextStyle(fontSize: 30),
              ),
            ),
            TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText: '请输入邮箱',
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[300])))),
            TextField(
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: '请输入密码',
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[300]))),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: FlatButton(
                    padding: EdgeInsets.only(left: 50, right: 50),
                    onPressed: () {},
                    child: Text('登 录'),
                    color: Colors.indigoAccent,
                    textColor: Colors.white,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: FlatButton(
                    padding: EdgeInsets.only(left: 50, right: 50),
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

  Widget _buildRegister() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[100], borderRadius: BorderRadius.circular(16)),
        padding: EdgeInsets.fromLTRB(30, 40, 30, 40),
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Text(
                '注  册',
                style: TextStyle(fontSize: 30),
              ),
            ),
            TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText: '请输入昵称',
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[300])))),
            TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText: '请输入邮箱',
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[300])))),
            TextField(
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: '请输入密码',
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[300]))),
            ),
            TextField(
              keyboardType: TextInputType.text,
              obscureText: true,
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
                    padding: EdgeInsets.only(left: 50, right: 50),
                    onPressed: () {},
                    child: Text('注 册'),
                    color: Colors.indigoAccent,
                    textColor: Colors.white,
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 20),
                    child: FlatButton(
                      padding: EdgeInsets.only(left: 50, right: 50),
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
