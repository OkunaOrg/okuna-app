import 'package:Okuna/plugins/share/share.dart' as SharePlugin;
import 'package:Okuna/services/media/media.dart';
import 'package:Okuna/services/share/models/share.dart';

class ShareSubscriber {
  final bool acceptsText;
  final bool acceptsImages;
  final bool acceptsVideos;
  final Future<dynamic> Function(Share) onShare;
  final void Function(MediaProcessingState, {dynamic data})
      mediaProgressCallback;

  const ShareSubscriber(this.acceptsText, this.acceptsImages,
      this.acceptsVideos, this.onShare, this.mediaProgressCallback);

  bool acceptsShare(SharePlugin.Share share) {
    return ((share.text == null || acceptsText) &&
        (share.image == null || acceptsImages) &&
        (share.video == null || acceptsVideos));
  }
}
