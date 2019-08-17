import 'package:flutter_web/material.dart';
import 'package:swiftclub/kit/kit.dart';
import 'package:swiftclub/components/header_view.dart';
//import 'package:flutter_web.examples.hello_world/components/footer_view.dart';
import 'package:swiftclub/components/markdown/markdown.dart';
import 'package:swiftclub/network/network.dart';

class DetailPage extends StatefulWidget {
  final int topicId;
  DetailPage({Key key, @required this.topicId}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _DetailPageState();
  }
}

class _DetailPageState extends State<DetailPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  Future<Map> loadTopic(context) async {
    Map response = await Network.getTopicDetail(widget.topicId);
    Map data = SafeValue.toMap(response['data']);
    Map topic = SafeValue.toMap(data['topic']);
    return Future.value(topic);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
        future: loadTopic(context),
        builder: (cxt, data) {
          if (data.hasData) {
            String content = SafeValue.toStr(data.data['content']);
            String title = SafeValue.toStr(data.data['title']);
            var body = data.hasData
                ? _buildBody(contentMd: content, title: title)
                : Center(
                    child: CircularProgressIndicator(),
                  );
            return Scaffold(
                backgroundColor: Colors.white,
                appBar: PreferredSize(
                    child: HeaderView(), preferredSize: Size.fromHeight(50)),
                body: body);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _buildBody({String contentMd, String title}) {
    return Markdown(
      data: contentMd,
      styleSheet: _markdownCss(),
      padding: EdgeInsets.fromLTRB(250, 50, 250, 100),
      headerBuilder: (cxt) {
        return Container(
          margin: EdgeInsets.fromLTRB(0, 30, 0, 50),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(color: Color(0xff333333), fontSize: 40),
          ),
        );
      },
    );
  }

  MarkdownStyleSheet _markdownCss() {
    var theme = Theme.of(context);
    var style = theme.textTheme.body1.copyWith(
        fontSize: 16,
        height: 1.8,
        color: Color(0xff333333),
        fontFamily: 'Helvetica');
    return MarkdownStyleSheet.fromTheme(theme).copyWith(
      a: style.copyWith(
          color: Color(0xff35b378),
          decoration: TextDecoration.underline,
          decorationColor: Color(0xff35b378)),
      h1: theme.textTheme.headline.copyWith(height: 2.5),
      h2: theme.textTheme.title.copyWith(height: 2),
      h3: theme.textTheme.subhead.copyWith(height: 1.8),
      h4: theme.textTheme.body2.copyWith(height: 1.7),
      h5: theme.textTheme.body2.copyWith(height: 1.6),
      h6: theme.textTheme.body2.copyWith(height: 1.5),
      code: style,
      p: style,
      img: style,
      blockquote: style.copyWith(color: Color(0xff616161)),
      blockquoteDecoration: BoxDecoration(
        color: Color(0xffFBF9FD),
        border: Border(
          left: BorderSide(
            color: Color(0xff35b378),
            width: 5,
          ),
        ),
      ),
      blockquotePadding: 15,
    );
  }
}
