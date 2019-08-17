import 'package:flutter_web/material.dart';
import '../flutter_markdown/flutter_markdown.dart' as md;
import 'syntax_highlighter.dart';
import 'dart_syntax_highlighter.dart';

final hightlighter = HighLight();

class HighLight extends md.SyntaxHighlighter {
  @override
  TextSpan format(String source) {
    final SyntaxHighlighterStyle style =
        SyntaxHighlighterStyle.lightThemeStyle();
    return TextSpan(
        style: const TextStyle(fontSize: 10),
        children: [DartSyntaxHighlighter(style).format(source)]);
  }
}
