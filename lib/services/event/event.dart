import 'models/event.dart';
import 'models/listener.dart';
import 'models/subscription.dart';

class EventService {
  Map<Type, List<EventListener>> subscribers;

  /// Register a subscriber for a specific event type.
  /// By default the subscriber will be added to the front of the subscriber list
  /// (and thus receive new events first). Use [append] if the subscriber should be
  /// added to the end of the list instead.
  EventSubscription subscribe<T extends Event>(EventListener<T> listener,
      {bool append = false}) {
    var subList = subscribers.putIfAbsent(T, () => <EventListener>[]);

    if (!append) {
      subList.insert(0, listener);
    } else {
      subList.add(listener);
    }

    return EventSubscription(() => subList.remove(listener));
  }

  Future<void> post(Event event) async {
    var subList = subscribers[event.runtimeType] ?? [];
    for (var sub in subList) {
      await sub(event);

      if (event.consumed) {
        break;
      }
    }
  }
}