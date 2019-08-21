import 'package:flutter_web/material.dart';

abstract class BlocBase {
  void initState();
  void dispose();
}

class BlocProvider<T extends BlocBase> extends StatefulWidget {
  BlocProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  }) : super(key: key);

  final T bloc;
  final Widget child;

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static T of<T extends BlocBase>(BuildContext context) {
    final type = _typeOf<BlocProvider<T>>();
    BlocProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;
}

class _BlocProviderState<T> extends State<BlocProvider<BlocBase>> {
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.bloc.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class PullLoadWidgetControl extends ChangeNotifier {
  List _dataList = List();

  get dataList => _dataList;

  set dataList(List value) {
    _dataList.clear();
    if (value != null) {
      _dataList.addAll(value);
      notifyListeners();
    }
  }

  addList(List value) {
    if (value != null) {
      _dataList.addAll(value);
      notifyListeners();
    }
  }

  ///是否需要加载更多
  bool _needLoadMore = true;

  set needLoadMore(value) {
    _needLoadMore = value;
    notifyListeners();
  }

  get needLoadMore => _needLoadMore;

  ///是否需要头部
  bool _needHeader = true;
  set needHeader(value) {
    _needHeader = value;
    notifyListeners();
  }

  get needHeader => _needHeader;

  ///是否加载中
  bool isLoading = false;
}

abstract class BlocListBase extends BlocBase {
  bool _isShow = false;
  int _page = 1;

  final PullLoadWidgetControl pullLoadWidgetControl = PullLoadWidgetControl();

  @mustCallSuper
  @override
  void initState() {
    _isShow = true;
  }

  @mustCallSuper
  @override
  void dispose() {
    _isShow = false;
    pullLoadWidgetControl.dispose();
  }

  @protected
  pageReset() {
    _page = 1;
  }

  @protected
  pageUp() {
    _page++;
  }

  ///列表数据长度
  int getDataLength() {
    return pullLoadWidgetControl.dataList.length;
  }

  @protected
  getLoadMoreStatus(res) {
    /// ispage
    return (res != null);
  }

  int get page => _page;

  ///修改加载更多
  changeLoadMoreStatus(bool needLoadMore) {
    pullLoadWidgetControl.needLoadMore = needLoadMore;
  }

  ///是否需要头部
  changeNeedHeaderStatus(bool needHeader) {
    pullLoadWidgetControl.needHeader = needHeader;
  }

  ///列表数据
  get dataList => pullLoadWidgetControl.dataList;

  ///刷新列表数据
  refreshData(res) {
    if (res != null) {
      pullLoadWidgetControl.dataList = res;
    }
  }

  ///加载更多数据
  loadMoreData(res) {
    if (res != null) {
      pullLoadWidgetControl.addList(res);
    }
  }

  ///清理数据
  clearData() {
    refreshData([]);
  }
}
