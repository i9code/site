class SafeValue {
  static String toStr(dynamic value) {
    if (value is String) {
      return value;
    } else {
      return '$value';
    }
  }

  static List toList(dynamic value) {
    if (value is List) {
      return value;
    } else {
      return [];
    }
  }

  static Map toMap(dynamic value) {
    if (value is Map) {
      return value;
    } else {
      return {};
    }
  }

  static int toInt(dynamic value) {
    if (value is int) {
      return value;
    }
    var ret = int.tryParse(value);
    if (ret == null) {
      ret = 0;
    }
    return ret;
  }
}
