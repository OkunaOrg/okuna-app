import 'package:Openbook/services/toast.dart';
import 'package:flutter/material.dart';

class OpenbookToast extends StatefulWidget {
  final Widget child;

  OpenbookToast({this.child});

  @override
  OpenbookToastState createState() {
    return OpenbookToastState();
  }

  static OpenbookToastState of(BuildContext context) {
    final OpenbookToastState toastState = context
        .rootAncestorStateOfType(const TypeMatcher<OpenbookToastState>());
    toastState._setCurrentContext(context);
    return toastState;
  }
}

class OpenbookToastState extends State<OpenbookToast>
    with SingleTickerProviderStateMixin {
  OverlayEntry _overlayEntry;
  BuildContext _currentContext;
  AnimationController controller;
  Animation<Offset> offset;

  static const double TOAST_CONTAINER_HEIGHT = 75.0;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 0.1))
        .animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return _OpenbookToast(
      child: widget.child,
    );
  }

  Future showToast(
      {@required Color color,
      String message,
      Widget child,
      VoidCallback onDismissed}) async {
    await _dismissToast();
    this._overlayEntry = this._createOverlayEntryFromTop(
        color: color, message: message, onDismissed: onDismissed, child: child);
    final overlay = Overlay.of(_currentContext);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => overlay.insert(_overlayEntry));
    controller.forward();
    _dismissToastAfterDelay();
  }

  void _dismissToastAfterDelay() async {
    await new Future.delayed(const Duration(seconds: 3));
    // Might have been already dismissed
    if (_overlayEntry != null) _dismissToast();
  }

  Future _dismissToast() async {
    if (this._overlayEntry == null) return;
    await controller.reverse();
    this._overlayEntry.remove();
    this._overlayEntry = null;
  }

  OverlayEntry _createOverlayEntryFromTop(
      {@required Color color,
      String message,
      Widget child,
      VoidCallback onDismissed}) {
    return OverlayEntry(builder: (context) {
      final MediaQueryData existingMediaQuery = MediaQuery.of(context);
      // 44 is header height
      double paddingTop = existingMediaQuery.padding.top + 44;

      return Stack(children: [
        Positioned(
            left: 0,
            width: existingMediaQuery.size.width,
            child: GestureDetector(
              onTap: () {
                if (onDismissed != null) onDismissed();
                _dismissToast();
              },
              child: _buildToast(
                  paddingTop: paddingTop,
                  color: color,
                  message: message,
                  child: child),
            ))
      ]);
    });
  }

  Widget _buildToast(
      {@required double paddingTop,
      @required Color color,
      @required String message,
      Widget child}) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: paddingTop),
                      child: SlideTransition(
                        position: offset,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(50)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    child ??
                                        Flexible(
                                          child: Text(
                                            message,
                                            style:
                                                TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                  mainAxisSize: MainAxisSize.min,
                ),
              )
            ],
            mainAxisSize: MainAxisSize.max,
          ),
        ],
      ),
    );
  }

  void _setCurrentContext(BuildContext context) {
    setState(() {
      _currentContext = context;
    });
  }
}

class _OpenbookToast extends InheritedWidget {
  _OpenbookToast({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_OpenbookToast old) {
    return true;
  }
}
