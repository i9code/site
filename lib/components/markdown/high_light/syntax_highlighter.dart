import 'package:flutter_web/material.dart';

class SyntaxHighlighterStyle {
  SyntaxHighlighterStyle(
      {this.baseStyle,
      this.numberStyle,
      this.commentStyle,
      this.keywordStyle,
      this.stringStyle,
      this.punctuationStyle,
      this.classStyle,
      this.constantStyle});

  static SyntaxHighlighterStyle lightThemeStyle() {
    return SyntaxHighlighterStyle(
        baseStyle: const TextStyle(color: Color(0xFF000000)),
        numberStyle: const TextStyle(color: Color(0xFF1565C0)),
        commentStyle: const TextStyle(color: Color(0xFF9E9E9E)),
        keywordStyle: const TextStyle(color: Color(0xFF9C27B0)),
        stringStyle: const TextStyle(color: Color(0xFF43A047)),
        punctuationStyle: const TextStyle(color: Color(0xFF000000)),
        classStyle: const TextStyle(color: Color(0xFF512DA8)),
        constantStyle: const TextStyle(color: Color(0xFF795548)));
  }

  static SyntaxHighlighterStyle darkThemeStyle() {
    return SyntaxHighlighterStyle(
        baseStyle: const TextStyle(color: Color(0xFFFFFFFF)),
        numberStyle: const TextStyle(color: Color(0xFF1565C0)),
        commentStyle: const TextStyle(color: Color(0xFF9E9E9E)),
        keywordStyle: const TextStyle(color: Color(0xFF80CBC4)),
        stringStyle: const TextStyle(color: Color(0xFF009688)),
        punctuationStyle: const TextStyle(color: Color(0xFFFFFFFF)),
        classStyle: const TextStyle(color: Color(0xFF009688)),
        constantStyle: const TextStyle(color: Color(0xFF795548)));
  }

  final TextStyle baseStyle;
  final TextStyle numberStyle;
  final TextStyle commentStyle;
  final TextStyle keywordStyle;
  final TextStyle stringStyle;
  final TextStyle punctuationStyle;
  final TextStyle classStyle;
  final TextStyle constantStyle;
}

abstract class Highlighter {
  // ignore: one_member_abstracts
  TextSpan format(String src);
}
