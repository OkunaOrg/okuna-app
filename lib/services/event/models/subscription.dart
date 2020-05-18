import 'package:flutter/material.dart';

class EventSubscription {
  /// Cancels this subscription so that it will no longer receive events.
  /// A cancelled subscription cannot be resumed.
  final VoidCallback cancel;

  const EventSubscription(this.cancel);
}