import 'package:flutter_web/material.dart';
import 'package:swiftclub/components/components.dart';
import 'package:swiftclub/models/models.dart';
import 'package:swiftclub/network/network.dart';
import 'package:swiftclub/kit/kit.dart';
import 'package:swiftclub/pages/booklet/model/catalog.dart';

class BookletPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BookletPageState();
  }
}

class _BookletPageState extends State<BookletPage> {
  List _catelogs;
  Catalog _selectCatalog;
  Topic _currentTopic;

  @override
  void initState() {
    super.initState();
    _loadBookCatalogs();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHud(
      child: Scaffold(
        appBar: PreferredSize(
          child: HeaderView(),
          preferredSize: Size.fromHeight(50),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildBookCatalog(),
          Expanded(
            child: _buildTopic(),
          )
        ],
      ),
    );
  }

  Widget _buildBookCatalog() {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      margin: EdgeInsets.only(left: 10, top: 10),
      width: MediaQuery.of(context).size.width * 200 / 1024.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _buildCatalogs(),
          Container(
            width: MediaQuery.of(context).size.width * 200 / 1024.0,
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey))),
            padding: EdgeInsets.only(left: 10),
            child: Builder(builder: (context) {
              return FlatButton(
                color: Colors.blue,
                child: Text(
                  '+新建页面',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => _createCatalog(context),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTopic() {
    String md = "";
    String title = "";
    if (_currentTopic != null && _currentTopic.content != null) {
      md = _currentTopic.content;
      title = _currentTopic.title;
    }
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: Markdown(
        data: md,
        enableScroll: false,
        styleSheet: _markdownCss(),
        padding: EdgeInsets.fromLTRB(0, 50, 0, 100),
        headerBuilder: (cxt) {
          return Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text(
              title,
              style: TextStyle(color: Color(0xff333333), fontSize: 30),
            ),
          );
        },
      ),
    );
  }

  MarkdownStyleSheet _markdownCss() {
    var theme = Theme.of(context);
    var style = theme.textTheme.body1.copyWith(
        fontSize: 14,
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

  Widget _buildCatalogs() {
    if (_catelogs == null || _catelogs.isEmpty) {
      return Container(
        child: Text('空'),
      );
    }
    List<Widget> childs = [];
    for (Map catalogMap in _catelogs) {
      Catalog catalog = Catalog.fromJson(catalogMap);
      childs.add(_buildCatalogTree(catalog));
    }
    return Container(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: childs),
      decoration: BoxDecoration(
          border: Border(left: BorderSide(color: Colors.green, width: 5))),
    );
  }

  Widget _buildCatalogTree(Catalog catalog) {
    List<Widget> childWidgets = [];

    bool isSelect = false;
    if (_selectCatalog != null) {
      isSelect = catalog.id == _selectCatalog.id;
    }

    childWidgets.add(Container(
      decoration: BoxDecoration(
          color: isSelect ? Colors.red : Colors.blue[300],
          border: Border(left: BorderSide(color: Colors.grey, width: 1))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            child: Text(
              catalog.title,
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => _onTapCatalog(catalog),
          ),
          GestureDetector(
            onTapDown: (TapDownDetails details) {
              final RenderBox box = context.findRenderObject();
              final Offset localOffset =
                  box.globalToLocal(details.globalPosition);

              Rect rect = Rect.fromLTWH(localOffset.dx, localOffset.dy, 0, 0);
              _catalogEdit(catalog, rect);
            },
            child: Container(
              margin: EdgeInsets.only(left: 10),
              color: Colors.blue,
              child: Icon(
                Icons.edit,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      margin: EdgeInsets.only(left: (catalog.level - 1) * 20.0, bottom: 5),
    ));

    for (Catalog child in catalog.child) {
      childWidgets.add(_buildCatalogTree(child));
    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: childWidgets,
      ),
    );
  }

  _onTapCatalog(Catalog catalog) {
    _changeToCatalog(catalog);
  }

  _changeToCatalog(Catalog catalog) {
    _selectCatalog = catalog;
    _loadTopic();
  }

  _catalogEdit(Catalog catalog, Rect rect) {
    // 弹气泡
    final menu = PopupMenu(
      maxColumn: 2,
      items: [
        MenuItem(
            title: '新建子页面',
            textStyle: TextStyle(fontSize: 14, color: Colors.white)),
        MenuItem(
            title: '删除',
            textStyle: TextStyle(fontSize: 14, color: Colors.white)),
      ],
      onClickMenu: (item) async {
        onClickMenu(item, catalog);
      },
      onDismiss: onDismiss,
    );
    menu.show(rect: rect);
  }

  void onClickMenu(MenuItemProvider item, Catalog catalog) async {
    String menuTitle = item.menuTitle;
    if (menuTitle == "删除") {
      Map response = await Network.deleteCatalog(catalog.id);
      int status = SafeValue.toInt(response['status']);
      if (status == 0) {
        _loadBookCatalogs();
      }
    } else if (menuTitle == "新建子页面") {}

    /// 重新加载数据
  }

  void onDismiss() {
    print('Menu is dismiss');
  }

  _loadBookCatalogs() async {
    Map response = await Network.getCatalogs();
    _catelogs = SafeValue.toList(response['data']);
    if (_catelogs != null && _catelogs.isNotEmpty) {
      _changeToCatalog(Catalog.fromJson(_catelogs.first));
    } else {
      setState(() {});
    }
  }

  _loadTopic() async {
    Map response =
        await Network.getTopicDetail(SafeValue.toInt(_selectCatalog.topicId));
    Map data = SafeValue.toMap(response['data']);
    Map topic = SafeValue.toMap(data['topic']);
    _currentTopic = Topic.fromJson(topic);
    setState(() {});
  }

  _createCatalog(context) async {
    Map catalog = {
      "title": "面试题",
      "pid": "1",
      "path": "0,1",
      "topicId": "1",
      "level": "1",
      "order": "1"
    };

    Map response = await Network.createCatalog(catalog);
    int status = SafeValue.toInt(response['status']);
    String message = SafeValue.toStr(response['message']);
    if (status == 0) {
      HudUtil.showSucceedHud(context, text: '创建成功');
      _loadBookCatalogs();
    } else {
      HudUtil.showErrorHud(context, text: message);
    }
  }
}
