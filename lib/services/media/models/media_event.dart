import 'package:async/async.dart';
import 'package:Okuna/services/event/models/event.dart';

class MediaProcessEvent extends Event {
  final MediaProcessingState state;
  final CancelableOperation operation;
  final dynamic data;

  MediaProcessEvent(this.state, {this.operation, this.data});
}

enum MediaProcessingState { picking, processing, finished, cancelled, error }