import 'package:Okuna/models/post_preview_link_data.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/link_preview.dart';
import 'package:Okuna/services/url_launcher.dart';
import 'package:Okuna/widgets/progress_indicator.dart';
import 'package:Okuna/widgets/theming/highlighted_box.dart';
import 'package:Okuna/widgets/theming/secondary_text.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_svg/svg.dart';
import 'package:async/async.dart';

class OBLinkPreview extends StatefulWidget {
  final LinkPreview linkPreview;
  final String link;
  final ValueChanged<LinkPreview> onLinkPreviewRetrieved;

  const OBLinkPreview(
      {this.linkPreview, this.link, this.onLinkPreviewRetrieved});

  @override
  State<StatefulWidget> createState() {
    return OBLinkPreviewState();
  }
}

class OBLinkPreviewState extends State<OBLinkPreview> {
  static double faviconSize = 16;
  static double imagePreviewHeight = 200;

  LinkPreview _linkPreview;
  LinkPreviewService _linkPreviewService;
  UrlLauncherService _urlLauncherService;

  bool _linkPreviewRequestInProgress;
  CancelableOperation _fetchLinkPreviewOperation;

  bool _needsBootstrap;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _linkPreview = widget.linkPreview;
    _linkPreviewRequestInProgress = false;
  }

  @override
  void dispose() {
    super.dispose();
    _fetchLinkPreviewOperation?.cancel();
  }

  void _bootstrap() {
    if (_linkPreview == null) {
      _retrieveLinkPreview();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      _linkPreviewService = openbookProvider.linkPreviewService;
      _urlLauncherService = openbookProvider.urlLauncherService;
      _bootstrap();
      _needsBootstrap = false;
    }

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: OBHighlightedBox(
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: _linkPreviewRequestInProgress
                      ? _buildRequestInProgress()
                      : _buildLinkPreview(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLinkPreview() {
    List<Widget> previewItems = [];

    if (_linkPreview.imageUrl != null) {
      previewItems.add(_buildPreviewImage());
    }

    previewItems.add(_buildPreviewBar());

    return GestureDetector(
      child: Column(children: previewItems),
      onTap: () {
        _urlLauncherService.launchUrl(_linkPreview.url);
      },
    );
  }

  Widget _buildRequestInProgress() {
    return SizedBox(
      // Estimated size of the preview bottom bar
      height: 150,
      child: Center(
        child: OBProgressIndicator(),
      ),
    );
  }

  Widget _buildPreviewImage() {
    return TransitionToImage(
      loadingWidget: SizedBox(
        height: imagePreviewHeight,
        child: Center(
          child: const OBProgressIndicator(),
        ),
      ),
      height: imagePreviewHeight,
      fit: BoxFit.cover,
      alignment: Alignment.center,
      image: AdvancedNetworkImage(_linkPreview.imageUrl,
          useDiskCache: false,
          fallbackAssetImage: 'assets/images/fallbacks/post-fallback.png',
          retryLimit: 3,
          timeoutDuration: const Duration(minutes: 1)),
      duration: const Duration(milliseconds: 300),
    );
  }

  Widget _buildPreviewBar() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _linkPreview.faviconUrl != null
                    ? _buildLinkPreviewFavicon()
                    : const SizedBox(),
                OBSecondaryText(_linkPreview.domainUrl.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
              ],
            ),
          ),
          OBText(
            _linkPreview.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          _linkPreview.description != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: OBText(
                    _linkPreview.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }

  Widget _buildLinkPreviewFavicon() {
    Widget faviconWidget;

    String faviconExtension = _linkPreview.faviconUrl.split('.').last;

    if (faviconExtension == 'svg') {
      faviconWidget = SvgPicture.network(
        _linkPreview.faviconUrl,
        semanticsLabel: 'Favicon',
        fit: BoxFit.cover,
        placeholderBuilder: (BuildContext context) =>
            Image.asset('assets/images/fallbacks/post-fallback.png'),
      );
    } else {
      faviconWidget = Image(
          fit: BoxFit.cover,
          image: AdvancedNetworkImage(_linkPreview.faviconUrl,
              useDiskCache: true));
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

  Future _retrieveLinkPreview() async {
    if (_fetchLinkPreviewOperation != null) return;
    _setLinkPreviewRequestInProgress(true);

    String link = widget.link;

    debugLog('Retrieving link preview for url: $link');

    try {
      _fetchLinkPreviewOperation =
          CancelableOperation.fromFuture(_linkPreviewService.previewLink(link));

      LinkPreview linkPreview = await _fetchLinkPreviewOperation.value;
      if (widget.onLinkPreviewRetrieved != null)
        widget.onLinkPreviewRetrieved(linkPreview);
      _setLinkPreview(linkPreview);
      debugLog('Retrieved link preview for url: $link');
    } catch (error) {
      debugLog('Failed to retrieve link preview for url: $link');
      throw error;
    } finally {
      _fetchLinkPreviewOperation = null;
      _setLinkPreviewRequestInProgress(false);
    }
  }

  void _setLinkPreviewRequestInProgress(bool previewRequestInProgress) {
    setState(() {
      _linkPreviewRequestInProgress = previewRequestInProgress;
    });
  }

  void _setLinkPreview(LinkPreview linkPreview) {
    setState(() {
      _linkPreview = linkPreview;
    });
  }

  void debugLog(String log) {
    debugPrint('OBLinkPreview:$log');
  }
}
