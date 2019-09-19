import 'package:flutter/material.dart';
import 'package:swiftclub/components/components.dart';
import 'package:swiftclub/models/models.dart';
import 'package:swiftclub/network/network.dart';
import 'package:swiftclub/kit/kit.dart';
import 'package:swiftclub/pages/booklet/model/catalog.dart';
import 'package:swiftclub/router/pop_route.dart';

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
            child: Container(
              constraints: BoxConstraints(maxWidth: 100),
              child: Text(
                catalog.title,
                maxLines: 2,
                style: TextStyle(color: Colors.white),
              ),
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
      maxColumn: 3,
      items: [
        MenuItem(
            title: '修改',
            textStyle: TextStyle(fontSize: 14, color: Colors.white)),
        MenuItem(
            title: '新建子页面',
            textStyle: TextStyle(fontSize: 14, color: Colors.white)),
        MenuItem(
            title: '删除',
            textStyle: TextStyle(fontSize: 14, color: Colors.white)),
      ],
      onClickMenu: (item) {
        onClickMenu(item, catalog);
      },
      onDismiss: onDismiss,
    );
    menu.show(rect: rect);
  }

  void onClickMenu(MenuItemProvider item, Catalog catalog) {
    String menuTitle = item.menuTitle;
    if (menuTitle == "删除") {
      Network.deleteCatalog(catalog.id).then((response) {
        int status = SafeValue.toInt(response['status']);
        if (status == 0) {
          _loadBookCatalogs();
        }
      });
    } else if (menuTitle == "新建子页面") {
      _popToCreateCatalog(catalog);
    } else if (menuTitle == "修改") {
      _popToEditCatalog(catalog);
    }
  }

  _popToEditCatalog(Catalog catalog) {
    Navigator.push(
        context,
        PopRoute(
            child: Popup(
          child: Container(
            width: MediaQuery.of(context).size.width * 800 / 1024.0,
            height: 500,
            color: Colors.white,
            child: _buildEditCatalogWidget(catalog),
          ),
        )));
  }

  _popToCreateCatalog(Catalog catalog) {
    Navigator.push(
        context,
        PopRoute(
            child: Popup(
          child: Container(
            width: MediaQuery.of(context).size.width * 800 / 1024.0,
            height: 500,
            color: Colors.white,
            child: _buildCreateCatalogWidget(catalog),
          ),
        )));
  }

  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  TextEditingController _editTitleController = TextEditingController();
  TextEditingController _editContentController = TextEditingController();

  Widget _buildEditCatalogWidget(Catalog catalog) {
    _editTitleController.text = catalog.title;

    return FutureBuilder(
        future: _loadEditTopic(topicId: catalog.topicId),
        builder: (ctx, snapshort) {
          if (snapshort.hasData) {
            Topic topic = snapshort.data as Topic;
            _editContentController.text = topic.content;
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    controller: _editTitleController,
                    decoration: InputDecoration(
                        labelText: "标题",
                        contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 12)),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 1),
                        ),
                      ),
                      constraints:
                          BoxConstraints(maxHeight: 300, minHeight: 200),
                      child: TextField(
                        controller: _editContentController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            labelText: '文章内容',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 12)),
                      )),
                  Container(
                      margin: EdgeInsets.only(top: 10, left: 10),
                      child: Builder(builder: (ctx) {
                        return FlatButton(
                            color: Colors.blue,
                            child: Text(
                              '更新',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              _editBookCatalog(ctx, catalog, topic);
                            });
                      }))
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  _editBookCatalog(BuildContext ctx, Catalog pCatalog, Topic topic) async {
    String title = _editTitleController.text;
    String content = _editContentController.text;
    debugPrint('title: $title, content: $content');
    if (title != pCatalog.title) {
      Map params = {
        "id": SafeValue.toStr(pCatalog.id),
        "pid": SafeValue.toStr(pCatalog.pid),
        "title": title,
        "path": pCatalog.path,
        "level": SafeValue.toStr(pCatalog.level),
        "order": SafeValue.toStr(pCatalog.order),
        "topicId": SafeValue.toStr(pCatalog.topicId)
      };
      await Network.updateCatalog(params);
    }
    Map nTopic = {
      "id": SafeValue.toStr(topic.id),
      "title": title,
      "content": content
    };
    Map response = await Network.updateTopic(nTopic);
    int status = SafeValue.toInt(response['status']);
    if (status == 0) {
      Navigator.of(ctx).pop();
      _loadBookCatalogs();
    }
  }

  Widget _buildCreateCatalogWidget(Catalog catalog) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
                labelText: "标题",
                hintText: "请输入标题",
                contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 12)),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey, width: 1),
              ),
            ),
            constraints: BoxConstraints(maxHeight: 300, minHeight: 200),
            child: TextField(
              controller: _contentController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                  labelText: '文章内容',
                  border: InputBorder.none,
                  hintText: "请输入文章内容(仅支持 markdown)",
                  contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 12)),
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 10, left: 10),
              child: Builder(builder: (ctx) {
                return FlatButton(
                    color: Colors.blue,
                    child: Text(
                      '新建文章',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _createBookCatalog(ctx, catalog);
                    });
              }))
        ],
      ),
    );
  }

  _createBookCatalog(BuildContext ctx, Catalog pCatalog) async {
    String title = _titleController.text;
    String content = _contentController.text;

    Map param = {
      'userId': DataHelper.userId(),
      'title': title,
      'subjectId': "5", // 小册
      'content': content,
      'textType': "1",
      'tags': "4", //其他
    };

    Map topicRes = await Network.createTopic(param);
    int status = SafeValue.toInt(topicRes['status']);
    if (status == 0) {
      Map topicData = SafeValue.toMap(topicRes['data']);
      String topicId = SafeValue.toStr(topicData['target']);

      String pid = pCatalog == null ? '0' : '${pCatalog.id}';
      String level = pCatalog == null ? '1' : '${pCatalog.level + 1}';
      String path = pCatalog == null ? '0' : pCatalog.path + ',${pCatalog.id}';
      Map catalog = {
        "title": title,
        "pid": pid,
        "path": path,
        "topicId": topicId,
        "level": level,
        "order": "1"
      };

      Map response = await Network.createCatalog(catalog);
      status = SafeValue.toInt(response['status']);
      if (status == 0) {
        Navigator.of(ctx).pop();
        _loadBookCatalogs();
      }
    }
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

  Future<Topic> _loadEditTopic({int topicId}) async {
    Map response = await Network.getTopicDetail(topicId);
    Map data = SafeValue.toMap(response['data']);
    Map topic = SafeValue.toMap(data['topic']);
    return Future.value(Topic.fromJson(topic));
  }

  _loadTopic() async {
    int topicId = SafeValue.toInt(_selectCatalog.topicId);
    Map response = await Network.getTopicDetail(topicId);
    Map data = SafeValue.toMap(response['data']);
    Map topic = SafeValue.toMap(data['topic']);
    _currentTopic = Topic.fromJson(topic);
    setState(() {});
  }

  _createCatalog(context) async {
    _popToCreateCatalog(null);
  }
}
