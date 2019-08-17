import 'package:flutter_web/material.dart';
import 'package:swiftclub/kit/kit.dart';
import 'package:swiftclub/components/components.dart';
import 'package:swiftclub/network/network.dart';

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IndexPageState();
  }
}

class _IndexPageState extends State<IndexPage> {
  Map response;

  List rows = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadData(1);
  }

  loadData(int page) async {
    setState(() {
      isLoading = true;
    });
    final response = await Network.getTopics({"page": page, "per": "10"});

    setState(() {
      this.response = response;
      isLoading = false;
      var data = SafeValue.toMap(response['data']);
      var tmpRows = SafeValue.toList(data['data']);
      if (page > 1) {
        rows.addAll(tmpRows);
      } else {
        rows = tmpRows;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody(context));
  }

  Widget _buildHeader(BuildContext context) {
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
              GestureDetector(
                onTap: _sigin,
                child: Container(
                  height: 50,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color(0xffF05138),
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(20))),
                  child: Text(
                    'S',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Image.network(
                    'https://swiftclub.loveli.site/assets/images/swift_logo.png'),
                width: 100,
                height: 100,
              ),
              Container(
                margin: EdgeInsets.only(left: 20),
                width: 750,
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

  _sigin() {
    Navigator.pushNamed(context, '/login');
  }

  Widget _buildBody(context) {
    if (response == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    var data = SafeValue.toMap(response['data']);
    var page = SafeValue.toMap(data['page']);
    var position = SafeValue.toMap(page['position']);
    var next = SafeValue.toInt(position['next']);
    var max = SafeValue.toInt(position['max']);

    List<Widget> lists = [_buildHeader(context)];

    lists.addAll(rows.map((item) {
      return _buildCell(item);
    }).toList());

    if (isLoading) {
      lists.add(Container(
        margin: EdgeInsets.only(top: 20),
        child: CircularProgressIndicator(),
      ));
    } else {
      if (next < max) {
        lists.add(GestureDetector(
          onTap: () {
            loadData(next);
          },
          child: Container(
            child: Text(
              '点击加载更多',
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
        ));
      } else {
        lists.add(Container(
          child: Text(
            '到底了，兄弟',
            style: TextStyle(color: Colors.grey),
          ),
        ));
      }
    }

    lists.add(Container(
      margin: EdgeInsets.only(top: 100),
      child: FooterView(),
    ));
    return SingleChildScrollView(
        child: Container(
      color: Colors.white,
      child: Column(
        children: lists,
      ),
    ));
  }

  Widget _buildCell(Map item) {
    Map topic = SafeValue.toMap(item['topic']);
    Map user = SafeValue.toMap(item['user']);

    ///
    var cell = Container(
        padding: EdgeInsets.fromLTRB(200, 10, 200, 10),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey[200], width: 1),
                  ),
                  width: 45,
                  height: 45,
                  alignment: Alignment.center,
                  child: FadeInImage.assetNetwork(
                      width: 25,
                      height: 25,
                      fit: BoxFit.cover,
                      placeholder: '',
                      image: SafeValue.toStr(user['avator'])),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          '09-07 10:09',
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          SafeValue.toStr(topic['title']),
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Divider(
              color: Colors.grey[200],
            )
          ],
        ));

    return GestureDetector(
      child: cell,
      onTap: () {
        print('topicID:: ${topic['id']}');
        Navigator.of(context).pushNamed('/detail',
            arguments: {"topicId": SafeValue.toInt(topic['id'])});
      },
    );
  }
}
