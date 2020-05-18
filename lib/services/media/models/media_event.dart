import 'package:Okuna/services/event/models/event.dart';

class MediaProcessEvent extends Event {
  final MediaProcessingState state;
  final dynamic data;

  MediaProcessEvent(this.state, {this.data});
}

enum MediaProcessingState { picking, processing, finished, cancelled, error }