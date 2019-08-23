import 'dart:convert';
import 'package:flutter_web/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:swiftclub/kit/data/data_helper.dart';
import 'package:swiftclub/kit/macro/macro.dart';

class Network {
  /// 业务接口
  /// 请求文章列表
  static getTopics(params) {
    return getReq('/topic/list', params: params);
  }

  static getAccountInfo() {
    return getReq('/account/info');
  }

  /// 请求文章详情
  static getTopicDetail(int topicId) {
    return getReq('/topic/$topicId');
  }

  static userLogin({@required String email, @required String passwd}) {
    return _postReq('/users/login',
        params: {'email': email, 'password': passwd});
  }

  static userRegister(
      {@required String email,
      @required String name,
      @required String passwd}) {
    return _postReq('/users/register',
        params: {'email': email, 'name': name, 'password': passwd});
  }

  /// 接口封装
  static getReq(String url, {Map params, Map headers}) async {
    var fullUrl = Macro.URL_base + url;
    return await _getReq(fullUrl, params: params, headers: headers);
  }

  static _getReq(String url, {Map params, Map headers}) async {
    var reqUri = _uriWith(url, queryParameters: params);
    Map<String, String> head = {};
    if (headers != null && headers.isNotEmpty) {
      head.addAll(headers);
    }
    final accessToken = DataHelper.accessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      head['Authorization'] = 'Bearer $accessToken';
    }
    http.Response response = await http.get(reqUri, headers: head);
    var responseBody = json.decode(response.body);
    return responseBody;
  }

  static _postReq(String url, {Map headers, Map params}) async {
    var fullUrl = Macro.URL_base + url;
    if (headers != null && headers.isNotEmpty) {
      http.Response response =
          await http.post(Uri.parse(fullUrl), headers: headers, body: params);
      var responseBody = json.decode(response.body);
      return responseBody;
    } else {
      http.Response response =
          await http.post(Uri.parse(fullUrl), body: params);
      var responseBody = json.decode(response.body);
      return responseBody;
    }
  }

  static Uri _uriWith(String url, {Map queryParameters}) {
    String _url = url;
    String query = _urlEncodeMap(queryParameters);
    if (query.isNotEmpty) {
      _url += (_url.contains("?") ? "&" : "?") + query;
    }
    // Normalize the url.
    return Uri.parse(_url).normalizePath();
  }

  static String _urlEncodeMap(data) {
    StringBuffer urlData = StringBuffer("");
    bool first = true;
    void urlEncode(dynamic sub, String path) {
      if (sub is List) {
        for (int i = 0; i < sub.length; i++) {
          urlEncode(sub[i],
              "$path%5B${(sub[i] is Map || sub[i] is List) ? i : ''}%5D");
        }
      } else if (sub is Map) {
        sub.forEach((k, v) {
          if (path == "") {
            urlEncode(v, "${Uri.encodeQueryComponent(k)}");
          } else {
            urlEncode(v, "$path%5B${Uri.encodeQueryComponent(k)}%5D");
          }
        });
      } else {
        if (!first) {
          urlData.write("&");
        }
        first = false;
        urlData.write("$path=${Uri.encodeQueryComponent(sub.toString())}");
      }
    }

    urlEncode(data, "");
    return urlData.toString();
  }
}
