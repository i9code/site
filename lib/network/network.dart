import 'dart:convert';
import 'package:http/http.dart' as http;

class Network {
  /// 业务接口
  /// 请求文章列表
  static getTopics(params) {
    return getReq('/topic/list', params: params);
  }

  /// 请求文章详情
  static getTopicDetail(int topicId) {
    return getReq('/topic/$topicId');
  }

  /// 接口封装

  static getReq(String url, {Map params, Map headers}) async {
    var fullUrl = 'https://sb.loveli.site/api' + url;
    return await _getReq(fullUrl, params: params, headers: headers);
  }

  static _getReq(String url, {Map params, Map headers}) async {
    var reqUri = _uriWith(url, queryParameters: params);
    http.Response response = await http.get(reqUri, headers: headers);
    var responseBody = json.decode(response.body);
    return responseBody;
  }

  static _postReq(String url, {Map headers, Map params}) async {
    var jsonParams = utf8.encode(json.encode(params));
    http.Response response =
        await http.post(Uri.parse(url), headers: headers, body: jsonParams);
    var responseBody = json.decode(response.body);
    return responseBody;
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
    StringBuffer urlData = new StringBuffer("");
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
