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
    final OpenbookToastState toastState =
    context.rootAncestorStateOfType(const TypeMatcher<OpenbookToastState>());
    toastState._setCurrentContext(context);
    return toastState;
  }
}

class OpenbookToastState extends State<OpenbookToast> with SingleTickerProviderStateMixin {
  OverlayEntry _overlayEntry;
  BuildContext _currentContext;
  double _cachedWidth;
  AnimationController controller;
  Animation<Offset> offset;
  Animation<Offset> offsetBottom;

  static const double TOAST_CONTAINER_HEIGHT = 75.0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 1.0))
        .animate(controller);

    offsetBottom = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, -1.0))
        .animate(controller);
  }


  @override
  Widget build(BuildContext context) {

    return _OpenbookToast(
      child: widget.child,
    );
  }

  void showToast(ToastConfig config) async {
    if (this._overlayEntry != null) this._overlayEntry.remove();
    this._overlayEntry = this._createOverlayEntryFromTop(config);
    final overlay = Overlay.of(_currentContext);
    WidgetsBinding.instance.addPostFrameCallback((_) => overlay.insert(_overlayEntry));
    controller.forward();
    _dismissToastAfterDelay();
  }

  void _dismissToastAfterDelay() async {
    await new Future.delayed(const Duration(seconds: 3));
    controller.reverse();
  }

  void _setWidthOfCurrentOverlay(BuildContext context) {
    setState(() {
      _cachedWidth = MediaQuery.of(_currentContext).size.width;
    });
  }

  OverlayEntry _createOverlayEntryFromTop(ToastConfig config) {

    _setWidthOfCurrentOverlay(_currentContext);

    return OverlayEntry(
        builder: (context) {
          return SafeArea(
            child: Stack(
              children: [
                Positioned(
              left: 0,
              top:  TOAST_CONTAINER_HEIGHT * -1.1,
              width: _cachedWidth,
              child: SlideTransition(
                position: offset,
                child: Material(
                  elevation: 4.0,
                  child: _getToastToBeDisplayed(config),
                  )
                )
              )
              ]
            )
          );
        }
    );
  }

  OverlayEntry _createOverlayEntryFromBottom(ToastConfig config) {

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
                        child: _getToastToBeDisplayed(config),
                      )
                  )
              )
            ],
          );
        }
    );
  }

  Widget _getToastToBeDisplayed(ToastConfig config) {
    if (config != null) {
      return Container(
        color: config.color,
        height: TOAST_CONTAINER_HEIGHT,
        padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
        child: Center(
          child: Text(config.message, style: TextStyle(color: Colors.white)
          )
        ),
      );
    }

    return const SizedBox();

  }

  void _setCurrentContext(BuildContext context) {
    setState(() {
      _currentContext = context;
    });
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