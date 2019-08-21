import 'package:swiftclub/kit/kit.dart';
import 'package:swiftclub/network/network.dart';
import 'package:swiftclub/models/models.dart';

class IndexBloc extends BlocListBase {
  requestRefresh() async {
    pageReset();
    return await _requestData();
  }

  requestLoadMore() async {
    pageUp();
    return await _requestData();
  }

  _requestData() async {
    final response = await Network.getTopics({"page": page, "per": 10});
    var data = SafeValue.toMap(response['data']);
    var rows = SafeValue.toList(data['data'])
        .map((json) => TopicEntity.fromJson(json))
        .toList();
    var rpage = RPage.fromJson(SafeValue.toMap(data['page']));
    changeLoadMoreStatus(getLoadMoreStatus(rpage));
    page > 1 ? loadMoreData(rows) : refreshData(rows);
    return data;
  }

  @override
  bool getLoadMoreStatus(res) {
    return res.position.max > res.position.current;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
