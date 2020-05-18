import 'event.dart';

typedef Future<void> EventListener<T extends Event>(T event);