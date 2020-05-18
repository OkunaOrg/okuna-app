import 'models/event.dart';
import 'models/listener.dart';
import 'models/subscription.dart';

class EventService {
  Map<Type, List<dynamic>> subscribers = {};

  /// Register a subscriber for a specific event type.
  /// By default the subscriber will be added to the front of the subscriber list
  /// (and thus receive new events first). Use [append] if the subscriber should be
  /// added to the end of the list instead.
  EventSubscription subscribe<T extends Event>(EventListener<T> listener,
      {bool append = false}) {
    var subList = subscribers.putIfAbsent(T, () => <EventListener<T>>[]);

    if (!append) {
      subList.insert(0, listener);
    } else {
      subList.add(listener);
    }

    post(SubscriptionEvent(T, subList.length, subList.length - 1));

    return EventSubscription(() => _unsubscribe(T, listener));
  }

  void _unsubscribe(Type eventType, dynamic listener) {
    var subList = subscribers[eventType];

    if (subList != null && subList.remove(listener)) {
      post(SubscriptionEvent(eventType, subList.length, subList.length + 1));
    }
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

  /// Returns the number of subscribers for the event type [T].
  int subscriberCount(Type eventType) {
    return subscribers[eventType]?.length ?? 0;
  }
}

/// An event which is send out every time a subscriber is added or removed.
class SubscriptionEvent extends Event {
  final Type eventType;
  final int newSubscriberCount;
  final int oldSubscriberCount;

  SubscriptionEvent(
      this.eventType, this.newSubscriberCount, this.oldSubscriberCount);
}
