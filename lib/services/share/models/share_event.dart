import 'package:Okuna/services/event/models/event.dart';
import 'package:Okuna/services/share/models/share.dart';

class ShareEvent extends Event {
  final ShareStatus status;
  final Share data;

  ShareEvent(this.status, {this.data});
}

enum ShareStatus { received, processed, cancelled }