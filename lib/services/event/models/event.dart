abstract class Event {
  bool _consumed = false;

  bool get consumed => _consumed;

  /// Consumes the event so that it will not be sent to any further subscribers.
  void consume() => _consumed = true;
}