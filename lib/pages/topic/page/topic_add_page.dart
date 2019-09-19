import 'package:flutter/material.dart';
import 'package:swiftclub/components/header_view.dart';
import 'package:swiftclub/components/dropdown_formfield/dropdown_formfield.dart';
import 'package:swiftclub/kit/kit.dart';
import 'package:swiftclub/network/network.dart';

class TopicAddPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TopicAddPageState();
  }
}

class _TopicAddPageState extends State<TopicAddPage> {
  List _subjects = [];
  List _tags = [];
  String _myActivity;
  String _myTags;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSubjects();
  }

  loadSubjects() async {
    Map response = await Network.getSubjects();
    _subjects = SafeValue.toList(response['data']);
    Map tagRes = await Network.getTags();
    _tags = SafeValue.toList(tagRes['data']);
    setState(() {});
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
                border: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.grey)),
                hintText: "请输入文章标题",
                labelText: '标题',
                contentPadding: EdgeInsets.fromLTRB(12, 20, 8, 20)),
          ),
          Container(
            margin: EdgeInsets.only(top: 2),
            width: MediaQuery.of(context).size.width * 200 / 1024.0,
            child: DropDownFormField(
              titleText: '分类',
              hintText: '选择分类',
              value: _myActivity,
              onSaved: (value) {
                setState(() {
                  _myActivity = value;
                });
              },
              onChanged: (value) {
                setState(() {
                  _myActivity = value;
                });
              },
              dataSource: _subjects,
              textField: 'name',
              valueField: 'id',
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 2),
            width: MediaQuery.of(context).size.width * 200 / 1024.0,
            child: DropDownFormField(
              titleText: '标签',
              hintText: '选择标签',
              value: _myTags,
              onSaved: (value) {
                setState(() {
                  _myTags = value;
                });
              },
              onChanged: (value) {
                setState(() {
                  _myTags = value;
                });
              },
              dataSource: _tags,
              textField: 'name',
              valueField: 'id',
            ),
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
                      _createTopic(ctx);
                    });
              }))
        ],
      ),
    );
  }

  _createTopic(context) async {
    String title = _titleController.text;
    String content = _contentController.text;
    Map param = {
      'userId': DataHelper.userId(),
      'title': title,
      'subjectId': _myActivity,
      'content': content,
      'textType': "1",
      'tags': _myTags
    };

    Map res = await Network.createTopic(param);
    int status = SafeValue.toInt(res['status']);
    String message = SafeValue.toStr(res['message']);
    if (status > 0) {
      HudUtil.showErrorHud(context, text: message);
    } else {
      HudUtil.showSucceedHud(context, text: '创建成功');
      await Navigator.of(context).pushNamed("/");
    }
  }
}
