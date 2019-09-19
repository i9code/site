import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

const int _timeSeconds = 1;

class HudUtil {
  static showLoadingHud(context, {String text}) async {
    show(context, hudType: ProgressHudType.loading, text: text);
    await Future.delayed(const Duration(seconds: _timeSeconds));
    dismiss(context);
  }

  static showErrorHud(context, {String text}) async {
    show(context, hudType: ProgressHudType.error, text: text);

    await Future.delayed(const Duration(seconds: _timeSeconds));
    dismiss(context);
  }

  static showSucceedHud(context, {String text}) async {
    show(context, hudType: ProgressHudType.success, text: text);

    await Future.delayed(const Duration(seconds: _timeSeconds));
    dismiss(context);
  }

  static show(context, {String text, ProgressHudType hudType}) async {
    ProgressHud.of(context).dismiss();
    ProgressHud.of(context).show(hudType ?? ProgressHudType.loading, text);
  }

  static dismiss(context) {
    ProgressHud.of(context).dismiss();
  }

  static showProgress(context, {String text}) {
    var hud = ProgressHud.of(context);
    hud.show(ProgressHudType.progress, text);

    double current = 0;
    Timer.periodic(Duration(milliseconds: 1000.0 ~/ 60), (timer) {
      current += 1;
      var progress = current / 100;
      hud.updateProgress(progress, "$text $current%");
      if (progress == 1) {
        hud.showAndDismiss(ProgressHudType.success, "完成");
        timer.cancel();
      }
    });
  }
}

// 以下来源自 bmprogresshud 插件 源码  https://pub.dev/packages/bmprogresshud#-readme-tab-
class CircleProgressBarPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color color;
  final Color fillColor;
  const CircleProgressBarPainter(
      {this.progress = 0,
      this.strokeWidth = 3,
      this.color = Colors.grey,
      this.fillColor = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    debugPrint('hud ------');
    final paint = new Paint()
      ..color = this.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final double diam = min(size.width, size.height);
    final centerX = size.width * 0.5;
    final centerY = size.height * 0.5;
    final radius = diam / 2.0;

    canvas.drawCircle(Offset(centerX, centerY), radius, paint);
    paint.color = this.fillColor;
    // draw in center
    var rect = Rect.fromLTWH((size.width - diam) * 0.5, 0, diam, diam);
    canvas.drawArc(rect, -0.5 * pi, progress * 2 * pi, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

enum ProgressHudType {
  /// show loading with CupertinoActivityIndicator and text
  loading,

  /// show Icons.check and Text
  success,

  /// show Icons.close and Text
  error,

  /// show circle progress view and text
  progress
}

/// show progresshud like ios app
class ProgressHud extends StatefulWidget {
  /// the offsetY of hudview postion from center, default is -50
  final double offsetY;
  final Widget child;

  static ProgressHudState of(BuildContext context) {
    return context.ancestorStateOfType(const TypeMatcher<ProgressHudState>());
  }

  ProgressHud({@required this.child, this.offsetY = -50, Key key})
      : super(key: key);

  @override
  ProgressHudState createState() => ProgressHudState();
}

// SingleTickerProviderStateMixin 动画
class ProgressHudState extends State<ProgressHud>
    with SingleTickerProviderStateMixin {
  AnimationController _animation;

  var _isVisible = false;
  var _text = "";
  var _opacity = 0.0;
  var _progressType = ProgressHudType.loading;
  var _progressValue = 0.0;

  @override
  void initState() {
    _animation = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this)
      ..addListener(() {
        setState(() {
          _opacity = _animation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          setState(() {
            _isVisible = false;
          });
        }
      });
    super.initState();
  }

  /// dismiss hud
  void dismiss() {
    _animation.reverse();
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  /// show hud with type and text
  void show(ProgressHudType type, String text) {
    _animation.forward();
    setState(() {
      _isVisible = true;
      _text = text;
      _progressType = type;
    });
  }

  /// show loading with text
  void showLoading({String text = "loading"}) {
    this.show(ProgressHudType.loading, text);
  }

  /// update progress value and text when ProgressHudType = progress
  ///
  /// should call `show(ProgressHudType.progress, "Loading")` before use
  void updateProgress(double progress, String text) {
    setState(() {
      _progressValue = progress;
      _text = text;
    });
  }

  /// show hud and dismiss automatically
  Future showAndDismiss(ProgressHudType type, String text) async {
    show(type, text);
    var millisecond = max(500 + text.length * 200, 1000);
    var duration = Duration(milliseconds: millisecond);
    await Future.delayed(duration);
    dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.child,
        !_isVisible
            ? Container()
            : Opacity(
                opacity: _opacity,
                child: _createHud(),
              )

//        Offstage(
//            offstage: !_isVisible,
//            child: Opacity(
//              opacity: _opacity,
//              child: _createHud(),
//            ))
      ],
    );
  }

  Widget _createHud() {
    const double kIconSize = 50;
    switch (_progressType) {
      case ProgressHudType.loading:
        var sizeBox = SizedBox(
            width: kIconSize,
            height: kIconSize,
            child: CupertinoActivityIndicator(animating: true, radius: 15));
        return _createHudView(sizeBox);
      case ProgressHudType.error:
        return _createHudView(
            Icon(Icons.close, color: Colors.white, size: kIconSize));
      case ProgressHudType.success:
        return _createHudView(
            Icon(Icons.check, color: Colors.white, size: kIconSize));
      case ProgressHudType.progress:
        var progressWidget = CustomPaint(
          painter: CircleProgressBarPainter(progress: _progressValue),
          size: Size(kIconSize, kIconSize),
        );
        return _createHudView(progressWidget);
      default:
        throw Exception("not implementation");
    }
  }

  Widget _createHudView(Widget child) {
    return Stack(
      children: <Widget>[
        // do not response touch event
        IgnorePointer(
          ignoring: false,
          child: Container(
            color: Colors.transparent,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Center(
          child: Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10 - widget.offsetY * 2),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 33, 33, 33),
                borderRadius: BorderRadius.circular(5)),
            constraints: BoxConstraints(
              minHeight: 130,
              minWidth: 130,
              maxWidth: 250,
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(12, 5, 12, 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    child: child,
                  ),
                  (_text != null && _text.isNotEmpty)
                      ? Container(
                          child: Text(
                            _text,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.none),
                          ),
                        )
                      : Container(
                          width: 100,
                          height: 0,
                          color: Colors.white,
                        )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
