import 'dart:async';

import 'package:Okuna/models/post_preview_link_data.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/httpie.dart';
import 'package:Okuna/services/link_preview.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/url_launcher.dart';
import 'package:Okuna/services/user.dart';
import 'package:Okuna/services/user_preferences.dart';
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
  UserPreferencesService _userPreferencesService;

  HttpieService _httpieService;

  bool _linkPreviewRequestInProgress;
  CancelableOperation _fetchLinkPreviewOperation;

  bool _needsBootstrap;
  String _errorMessage;

  StreamSubscription _linkPreviewsAreEnabledChangeSubscription;

  bool _linkPreviewsAreEnabled;

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
    _linkPreviewsAreEnabledChangeSubscription?.cancel();
  }

  void _bootstrap() async {
    _linkPreviewsAreEnabled =
        _userPreferencesService.getLinkPreviewsAreEnabled();

    _onLinkPreviewsAreEnabledChange(_linkPreviewsAreEnabled, isBootstrap: true);

    _linkPreviewsAreEnabledChangeSubscription = _userPreferencesService
        .linkPreviewsAreEnabledChange
        .listen(_onLinkPreviewsAreEnabledChange);
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      _linkPreviewService = openbookProvider.linkPreviewService;
      _urlLauncherService = openbookProvider.urlLauncherService;
      _localizationService = openbookProvider.localizationService;
      _httpieService = openbookProvider.httpService;
      _userPreferencesService = openbookProvider.userPreferencesService;
      _bootstrap();
      _needsBootstrap = false;
    }

    return _linkPreviewsAreEnabled
        ? ClipRRect(
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
          )
        : const SizedBox();
  }

  Widget _buildErrorMessage() {
    return SizedBox(
        // Estimated size of the preview bottom bar
        height: linkPreviewHeight,
        child: Column(
          children: <Widget>[
            Expanded(
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
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: OBHighlightedBox(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: OBSecondaryText(_getLinkPreviewDomain(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ),
                )
              ],
            )
          ],
        ));
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
        _urlLauncherService.launchUrl(_linkPreview.url ?? widget.link);
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
    if (_linkPreview.imageUrl == null && _linkPreview.image == null) {
      return Image.asset(
        'assets/images/fallbacks/post-fallback.png',
        fit: BoxFit.cover,
        alignment: Alignment.center,
      );
    }

    return _linkPreview.image != null
        ? _buildLinkPreviewImageFromBytes(_linkPreview.image)
        : _buildLinkPreviewImageFromUrl(_linkPreview.imageUrl);
  }

  Widget _buildLinkPreviewImageFromBytes(List<int> image) {
    return Semantics(
      label: 'Link preview image',
      child: Container(
        decoration: BoxDecoration(
            image:
                DecorationImage(fit: BoxFit.cover, image: MemoryImage(image))),
      ),
    );
  }

  Widget _buildLinkPreviewImageFromUrl(String url) {
    String proxiedImageUrl =
        _linkPreviewService.getProxiedLink(_linkPreview.imageUrl);
    String proxyAuthToken = _httpieService.getAuthorizationToken();

    return _buildCrossCompatImageForSource(proxiedImageUrl,
        semanticsLabel: 'Link preview image',
        headers: {'Authorization': 'Token $proxyAuthToken'});
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
                OBSecondaryText(_getLinkPreviewDomain(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
              ],
            ),
          ),
          _linkPreview.title != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: OBText(
                    _linkPreview.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              : const SizedBox(),
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

    String proxiedFaviconImageUrl =
        _linkPreviewService.getProxiedLink(_linkPreview.faviconUrl);
    String proxyAuthToken = _httpieService.getAuthorizationToken();

    faviconWidget = _buildCrossCompatImageForSource(proxiedFaviconImageUrl,
        semanticsLabel: 'Favicon',
        headers: {'Authorization': 'Token $proxyAuthToken'});

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

  Widget _buildCrossCompatImageForSource(String imageSource,
      {String semanticsLabel, Map<String, String> headers}) {
    String faviconExtension = imageSource.split('.').last;

    Widget image;

    if (faviconExtension == 'svg') {
      image = SvgPicture.network(
        imageSource,
        headers: headers,
        semanticsLabel: semanticsLabel,
        fit: BoxFit.cover,
        placeholderBuilder: (BuildContext context) =>
            Image.asset('assets/images/fallbacks/post-fallback.png'),
      );
    } else {
      image = Semantics(
        label: semanticsLabel,
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AdvancedNetworkImage(imageSource,
                      header: headers,
                      useDiskCache: true,
                      fallbackAssetImage:
                          'assets/images/fallbacks/post-fallback.png',
                      retryLimit: 3,
                      timeoutDuration: const Duration(minutes: 1)))),
        ),
      );
    }

    return image;
  }

  void _onLinkPreviewsAreEnabledChange(bool newAreLinkPreviewsEnabled,
      {bool isBootstrap = false}) {
    if (isBootstrap) {
      _linkPreviewsAreEnabled = newAreLinkPreviewsEnabled;
    } else {
      setState(() {
        _linkPreviewsAreEnabled = newAreLinkPreviewsEnabled;
      });
    }

    if (_linkPreview == null && newAreLinkPreviewsEnabled) {
      _retrieveLinkPreview();
    } else {
      // No link preview, requesting
      _linkPreviewRequestInProgress = false;
    }
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
        _setErrorMessage(_localizationService.post_body_link_preview__empty);
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
      String localizedErrorMessage =
          _localizationService.post_body_link_preview__error_with_description(
              error.toHumanReadableMessage());
      _setErrorMessage(localizedErrorMessage);
    } else if (error is HttpieRequestError) {
      String errorMessage = await error.toHumanReadableMessage();
      String localizedErrorMessage = _localizationService
          .post_body_link_preview__error_with_description(errorMessage);
      _setErrorMessage(localizedErrorMessage);
    } else if (error is EmptyLinkToPreview) {
      _setErrorMessage(_localizationService.post_body_link_preview__empty);
    } else {
      _setErrorMessage(_localizationService.error__unknown_error);
      throw error;
    }
  }

  String _getLinkPreviewDomain() {
    return (_linkPreview != null && _linkPreview.domainUrl != null
            ? _linkPreview.domainUrl
            : Uri.parse(widget.link).host)
        .toUpperCase();
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
