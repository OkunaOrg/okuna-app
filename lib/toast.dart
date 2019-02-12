import 'package:flutter/material.dart';

class OpenbookToast extends StatefulWidget {
  final Widget child;

  OpenbookToast({this.child});

  @override
  OpenbookToastState createState() {
    return OpenbookToastState();
  }

  static OpenbookToastState of(BuildContext context) {
    final OpenbookToastState toastState =
    context.rootAncestorStateOfType(const TypeMatcher<OpenbookToastState>());
    toastState._setCurrentContext(context);
    return toastState;
  }
}

class OpenbookToastState extends State<OpenbookToast> with SingleTickerProviderStateMixin {
  OverlayEntry _overlayEntry;
  String _message;
  BuildContext _currentContext;
  AnimationController controller;
  Animation<Offset> offset;
  Animation<Offset> offsetBottom;

  static const double TOAST_CONTAINER_HEIGHT = 70.0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 1.0))
        .animate(controller);

    offsetBottom = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, -1.0))
        .animate(controller);
  }

  void showToast(String message) async {
    // if (this._overlayEntry != null) this._overlayEntry.remove();
    this._message = message;
    this._overlayEntry = this._createOverlayEntryFromTop();
    final overlay = Overlay.of(_currentContext);
    WidgetsBinding.instance.addPostFrameCallback((_) => overlay.insert(_overlayEntry));
    controller.forward();
    _dismissToastAfterDelay();
  }

  void _dismissToastAfterDelay() async {
    await new Future.delayed(const Duration(seconds: 3));
    controller.reverse();
  }

  OverlayEntry _createOverlayEntryFromTop() {

    return OverlayEntry(
        builder: (context) {
          return Positioned(
          left: 0,
          top:  TOAST_CONTAINER_HEIGHT * -1.0,
          width: MediaQuery.of(_currentContext).size.width,
          child: SlideTransition(
            position: offset,
            child: Material(
              elevation: 4.0,
              child: _getToastToBeDisplayed(),
              )
          )
        );
      }
    );
  }

  OverlayEntry _createOverlayEntryFromBottom() {

    RenderBox renderBox = _currentContext.findRenderObject();
    var size = renderBox.size;
    var _boxOffset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
        builder: (context) {
          return new Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Positioned(
                  left: 0,
                  bottom: -1.0 * TOAST_CONTAINER_HEIGHT,
                  width: size.width,
                  child: SlideTransition(
                      position: offsetBottom,
                      child: Material(
                        elevation: 4.0,
                        child: _getToastToBeDisplayed(),
                      )
                  )
              )
            ],
          );
        }
    );
  }

  Widget _getToastToBeDisplayed() {
    if (_message != null) {
      return Container(
        color: Colors.redAccent,
        height: TOAST_CONTAINER_HEIGHT,
        padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
        child: Text(_message, style: TextStyle(color: Colors.white)),
      );
    }

    return const SizedBox();

  }

  void _setCurrentContext(BuildContext context) {
    setState(() {
      _currentContext = context;
    });
  }

  @override
  Widget build(BuildContext context) {

    return _OpenbookToast(
      child: widget.child,
    );
  }
}

class _OpenbookToast extends InheritedWidget {

  _OpenbookToast({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_OpenbookToast old) {
    return true;
  }
}