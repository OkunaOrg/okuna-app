import 'package:flutter/cupertino.dart';

abstract class OBBasePageState<T extends StatefulWidget> extends State<T> {
  int _pushedRoutes;

  @override
  void initState() {
    super.initState();
    _pushedRoutes = 0;
  }

  void scrollToTop();

  bool hasPushedRoutes() {
    return _pushedRoutes > 0;
  }

  void popUntilFirst() {
    Navigator.of(context).popUntil((Route<dynamic> r) => r.isFirst);
    _pushedRoutes = 0;
  }

  void incrementPushedRoutes() {
    _pushedRoutes += 1;
  }

  void decrementPushedRoutes() {
    if (_pushedRoutes == 0) return;
    _pushedRoutes -= 1;
  }
}

abstract class OBBasePageStateController<T extends OBBasePageState> {
  T state;

  void attach(T state) {
    assert(state != null, 'Cannot attach to empty state');
    this.state = state;
  }

  void popUntilFirst() {
    state.popUntilFirst();
  }

  void scrollToTop() {
    state.scrollToTop();
  }

  bool hasPushedRoutes() {
    return state.hasPushedRoutes();
  }
}
