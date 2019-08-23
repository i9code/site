import 'package:flutter_web/material.dart';
import 'package:swiftclub/components/components.dart';
import 'package:swiftclub/kit/kit.dart';
import 'package:swiftclub/network/network.dart';
import 'package:intl/intl.dart';
import '../view/view.dart';

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
    loadData();
  }

  loadData({int page = 1}) async {
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
    return Scaffold(
        body: ResponsiveWidget(
      largeScreen: _buildLargeScreen(context),
    ));
  }

  Widget _buildLargeScreen(context) {
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

    List<Widget> lists = [IndexHeaderView()];
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
            loadData(page: next);
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

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var date = DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    var diff = date.difference(now);
    var format = DateFormat('MM-dd');
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + 'DAY AGO';
      } else {
        time = diff.inDays.toString() + 'DAYS AGO';
      }
    }
    return time;
  }

  Widget _buildCell(Map item) {
    Map topic = SafeValue.toMap(item['topic']);
    Map user = SafeValue.toMap(item['user']);

    ///
    var cell = Center(
        child: Container(
            width: MediaQuery.of(context).size.width * 700 / 1024.0,
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Text(
                                readTimestamp(
                                        SafeValue.toInt(topic['createdAt'])) +
                                    '收录',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 18),
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
                      ),
                    )
                  ],
                ),
                Divider(
                  color: Colors.grey[200],
                )
              ],
            )));

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
