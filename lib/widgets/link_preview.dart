import 'package:Okuna/models/post_preview_link_data.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/httpie.dart';
import 'package:Okuna/services/link_preview.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/url_launcher.dart';
import 'package:Okuna/services/user.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/progress_indicator.dart';
import 'package:Okuna/widgets/theming/highlighted_box.dart';
import 'package:Okuna/widgets/theming/secondary_text.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
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
  static double linkPreviewHeight = 300;

  LinkPreview _linkPreview;
  LinkPreviewService _linkPreviewService;
  UrlLauncherService _urlLauncherService;
  LocalizationService _localizationService;

  HttpieService _httpieService;

  bool _linkPreviewRequestInProgress;
  CancelableOperation _fetchLinkPreviewOperation;

  bool _needsBootstrap;
  String _errorMessage;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _linkPreview = widget.linkPreview;
    _linkPreviewRequestInProgress = true;
  }

  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);

    String previousLinkUrl;
    if (oldWidget.link != null) {
      previousLinkUrl = oldWidget.link;
    } else {
      previousLinkUrl = oldWidget.linkPreview.url;
    }

    String newLinkUrl;
    if (widget.link != null) {
      newLinkUrl = widget.link;
    } else {
      newLinkUrl = widget.linkPreview.url;
    }

    if (previousLinkUrl != newLinkUrl) {
      _needsBootstrap = true;
      _linkPreview = widget.linkPreview;
      _linkPreviewRequestInProgress = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _fetchLinkPreviewOperation?.cancel();
  }

  void _bootstrap() {
    if (_linkPreview == null) {
      _retrieveLinkPreview();
    } else {
      // No link preview, requesting
      _linkPreviewRequestInProgress = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      _linkPreviewService = openbookProvider.linkPreviewService;
      _urlLauncherService = openbookProvider.urlLauncherService;
      _localizationService = openbookProvider.localizationService;
      _httpieService = openbookProvider.httpService;
      _bootstrap();
      _needsBootstrap = false;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: OBHighlightedBox(
          child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: _linkPreviewRequestInProgress || _linkPreview == null
                  ? _errorMessage != null
                      ? _buildErrorMessage()
                      : _buildRequestInProgress()
                  : _buildLinkPreview(),
            ),
          )
        ],
      )),
    );
  }

  Widget _buildErrorMessage() {
    return SizedBox(
      // Estimated size of the preview bottom bar
      height: linkPreviewHeight,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OBIcon(
              OBIcons.linkOff,
              size: OBIconSize.large,
            ),
            const SizedBox(
              height: 10,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 150),
              child: OBText(
                _errorMessage,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLinkPreview() {
    return GestureDetector(
      child: SizedBox(
          height: linkPreviewHeight,
          child: Column(
            children: [
              Expanded(
                child: _buildPreviewImage(),
              ),
              _buildPreviewBar()
            ],
          )),
      onTap: () {
        _urlLauncherService.launchUrl(_linkPreview.url);
      },
    );
  }

  Widget _buildRequestInProgress() {
    return SizedBox(
      // Estimated size of the preview bottom bar
      height: 300,
      child: Center(
        child: OBProgressIndicator(),
      ),
    );
  }

  Widget _buildPreviewImage() {
    Widget previewWidget;

    if (_linkPreview.imageUrl == null) {
      previewWidget = Image.asset(
        'assets/images/fallbacks/post-fallback.png',
        fit: BoxFit.cover,
        alignment: Alignment.center,
      );
    } else {
      String proxiedImageUrl =
          _linkPreviewService.getProxiedLink(_linkPreview.imageUrl);
      String proxyAuthToken = _httpieService.getAuthorizationToken();

      previewWidget = Semantics(
        label: 'Link preview image',
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AdvancedNetworkImage(proxiedImageUrl,
                      header: {'Authorization': 'Token $proxyAuthToken'},
                      useDiskCache: true,
                      fallbackAssetImage:
                          'assets/images/fallbacks/post-fallback.png',
                      retryLimit: 3,
                      timeoutDuration: const Duration(minutes: 1)))),
        ),
      );
    }

    return previewWidget;
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          _linkPreview.description != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: OBSecondaryText(
                    _linkPreview.description,
                    size: OBTextSize.mediumSecondary,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
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
              fallbackAssetImage: 'assets/images/fallbacks/post-fallback.png',
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
    _setErrorMessage(null);
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
      if (linkPreview != null) {
        _setLinkPreview(linkPreview);
        debugLog('Retrieved link preview for url: $link');
      } else {
        debugLog('Retrieved empty link preview for url: $link');
      }
    } catch (error) {
      debugLog('Failed to retrieve link preview for url: $link');
      _onError(error);
      throw error;
    } finally {
      _fetchLinkPreviewOperation = null;
      _setLinkPreviewRequestInProgress(false);
    }
  }

  void _onError(error) async {
    if (error is HttpieConnectionRefusedError) {
      _setErrorMessage(error.toHumanReadableMessage());
    } else if (error is HttpieRequestError) {
      String errorMessage = await error.toHumanReadableMessage();
      _setErrorMessage(errorMessage);
    } else if (error is EmptyLinkToPreview) {
      _setErrorMessage(_localizationService.post_body_link_preview__empty);
    } else {
      _setErrorMessage(_localizationService.error__unknown_error);
      throw error;
    }
  }

  void _setErrorMessage(String errorMessage) {
    setState(() {
      _errorMessage = errorMessage;
    });
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
    //debugPrint('OBLinkPreview:$log');
  }
}
