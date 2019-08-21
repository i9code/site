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

  static double toDouble(dynamic value) {
    if (value is double) {
      return value;
    }
    var ret = double.tryParse(value);
    if (ret == null) {
      ret = 0;
    }
    return ret;
  }

  static bool toBool(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is String) {
      return value == true.toString();
    }
    if (value is num) {
      return value > 0;
    }
    return false;
  }
}
