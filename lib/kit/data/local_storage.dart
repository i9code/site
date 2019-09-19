@JS()
library storage;

import 'package:js/js.dart';

external Storage get localStorage;

@JS()
class Storage {
  int length;
  external dynamic getItem(String key);
  external void setItem(String key, dynamic item);
  external void removeItem(String key);
  external void clear();
}
