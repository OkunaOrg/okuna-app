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
import 'package:flutter_svg/svg.dart';

class OBLinkPreview extends StatelessWidget {
  final LinkPreview linkPreview;

  static double faviconSize = 16;

  const OBLinkPreview({@required this.linkPreview});

  @override
  Widget build(BuildContext context) {
    // String previewLink = this.post.getPreviewLink();
    double screenWidth = MediaQuery.of(context).size.width;
    UrlLauncherService _urlLauncherService =
        OpenbookProvider.of(context).urlLauncherService;

    return GestureDetector(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Column(
          children: <Widget>[
            linkPreview.imageUrl != null
                ? _buildPreviewImage(screenWidth, this.linkPreview)
                : const SizedBox(),
            _buildPreviewBar(this.linkPreview, context)
          ],
        ),
      ),
      onTap: () {
        _urlLauncherService.launchUrl(this.linkPreview.url);
      },
    );
  }

  Widget _buildPreviewImage(double screenWidth, LinkPreview data) {
    if (data.imageUrl == null) return SizedBox();

    return TransitionToImage(
      loadingWidget: SizedBox(
        height: 200,
        child: Center(
          child: const OBProgressIndicator(),
        ),
      ),
      height: 200,
      width: screenWidth,
      fit: BoxFit.cover,
      alignment: Alignment.center,
      image: AdvancedNetworkImage(data.imageUrl,
          useDiskCache: false,
          fallbackAssetImage: 'assets/images/fallbacks/post-fallback.png',
          retryLimit: 3,
          timeoutDuration: const Duration(minutes: 1)),
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _buildFavicon(),
                  OBSecondaryText(data.domainUrl.toUpperCase(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
                ],
              ),
            ),
            OBText(
              data.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: OBText(
                data.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFavicon() {
    if (linkPreview.faviconUrl == null) return const SizedBox();
    Widget faviconWidget;

    String faviconExtension = linkPreview.faviconUrl.split('.').last;

    if (faviconExtension == 'svg') {
      faviconWidget = SvgPicture.network(
        linkPreview.faviconUrl,
        semanticsLabel: 'Favicon',
        fit: BoxFit.cover,
        placeholderBuilder: (BuildContext context) =>
            Image.asset('assets/images/fallbacks/post-fallback.png'),
      );
    } else {
      faviconWidget = Image(
          fit: BoxFit.cover,
          image:
              AdvancedNetworkImage(linkPreview.faviconUrl, useDiskCache: true));
    }

    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3.0),
        child: SizedBox(
          height: faviconSize,
          width: faviconSize,
          child: faviconWidget,
        ),
      ),
    );
  }
}
