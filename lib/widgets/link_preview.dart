import 'package:Okuna/models/post_preview_link_data.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/url_launcher.dart';
import 'package:Okuna/widgets/progress_indicator.dart';
import 'package:Okuna/widgets/theming/highlighted_box.dart';
import 'package:Okuna/widgets/theming/secondary_text.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

class OBLinkPreview extends StatelessWidget {
  final LinkPreview linkPreview;

  const OBLinkPreview({@required this.linkPreview});

  @override
  Widget build(BuildContext context) {
    // String previewLink = this.post.getPreviewLink();
    double screenWidth = MediaQuery.of(context).size.width;
    UrlLauncherService _urlLauncherService =
        OpenbookProvider.of(context).urlLauncherService;

    print('Got this link preview');
    print(linkPreview);

    return GestureDetector(
      child: Column(
        children: <Widget>[
          _buildPreviewImage(screenWidth, this.linkPreview),
          _buildPreviewBar(this.linkPreview, context)
        ],
      ),
      onTap: () {
        _urlLauncherService.launchUrl(this.linkPreview.url);
      },
    );
  }

  Widget _buildPreviewImage(double screenWidth, LinkPreview data) {
    if (data.imageUrl == null) return SizedBox();

    return TransitionToImage(
      width: screenWidth,
      fit: BoxFit.contain,
      alignment: Alignment.center,
      image: AdvancedNetworkImage(data.imageUrl,
          useDiskCache: false,
          fallbackAssetImage: 'assets/images/fallbacks/post-fallback.png',
          retryLimit: 0,
          timeoutDuration: const Duration(minutes: 1)),
      placeholder: Center(
        child: const OBProgressIndicator(),
      ),
      duration: const Duration(milliseconds: 300),
    );
  }

  Widget _buildPreviewBar(LinkPreview data, BuildContext context) {
    return OBHighlightedBox(
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                data.faviconUrl != null
                    ? Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Image(
                            width: 20.0,
                            height: 20.0,
                            image: AdvancedNetworkImage(data.faviconUrl,
                                useDiskCache: true)),
                      )
                    : const SizedBox(),
                OBSecondaryText(data.domainUrl.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
              ],
            ),
            OBText(
              data.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            OBText(
              data.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
