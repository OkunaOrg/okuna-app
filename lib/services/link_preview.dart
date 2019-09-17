import 'package:Okuna/models/post_preview_link_data.dart';
import 'package:Okuna/services/httpie.dart';
import 'package:Okuna/services/validation.dart';
import 'package:Okuna/widgets/theming/smart_text.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:public_suffix/public_suffix_io.dart';

class LinkPreviewService {
  ValidationService _validationService;
  HttpieService _httpieService;

  String _trustedProxyUrl = '';

  LinkPreviewService() {
    _initPublicSuffixes();
  }

  void _initPublicSuffixes() async {
    String publicSuffixes =
        await rootBundle.loadString('assets/other/public_suffix_list.dat');
    SuffixRules.initFromString(publicSuffixes);
  }

  void setTrustedProxyUrl(String proxyUrl) {
    _trustedProxyUrl = proxyUrl;
  }

  void setHttpieService(httpieService) {
    _httpieService = httpieService;
  }

  void setValidationService(validationService) {
    _validationService = validationService;
  }

  bool hasLinkPreviewUrl(String text) {
    return checkForLinkPreviewUrl(text) != null;
  }

  String checkForLinkPreviewUrl(String text) {
    List matches = [];
    String previewUrl;
    matches.addAll(linkRegex.allMatches(text).map((match) {
      return match.group(0);
    }));

    if (matches.length > 0) {
      previewUrl = matches.first;
    }
    return previewUrl;
  }

  Future<LinkPreview> previewLink(String link) async {
    String normalisedLink = _normaliseLink(link);

    if (!_validationService.isUrl(normalisedLink))
      throw InvalidLinkToPreview(normalisedLink);

    bool appendAuthorizationHeader = _trustedProxyUrl.isNotEmpty;

    HttpieResponse response;

    if (!normalisedLink.startsWith('https://')) {
      try {
        String secureLink = normalisedLink.replaceFirst('http', 'https');
        print('Secure Link $secureLink');
        response = await _httpieService.get(getProxiedLink(secureLink),
            appendAuthorizationToken: appendAuthorizationHeader);
        normalisedLink = secureLink;
      } on HttpieRequestError {
        response = await _httpieService.get(getProxiedLink(normalisedLink),
            appendAuthorizationToken: appendAuthorizationHeader);
      }
    } else {
      response = await _httpieService.get(getProxiedLink(normalisedLink),
          appendAuthorizationToken: appendAuthorizationHeader);
    }

    _checkResponseIsOk(response);

    return _getLinkPreviewFromResponseBody(
        link: normalisedLink, responseBody: response.body);
  }

  LinkPreview _getLinkPreviewFromResponseBody(
      {@required String link, @required String responseBody}) {
    Document document = parser.parse(responseBody);

    // Assigned with iterated og tags
    String linkPreviewTitle;
    String linkPreviewDescription;
    String linkPreviewImageUrl;
    String linkPreviewSiteName;
    String linkPreviewDomainUrl = Uri.parse(link).host;
    // Assigned separately
    String linkPreviewFaviconUrl = _getLinkPreviewFaviconUrl(document);

    var openGraphMetaTags = document.head.querySelectorAll("[property*='og:']");

    openGraphMetaTags.forEach((openGraphMetaTag) {
      String ogTagName =
          openGraphMetaTag.attributes['property'].split("og:")[1];
      String ogTagValue = openGraphMetaTag.attributes['content'];

      if (ogTagName == 'title') {
        if (ogTagValue == null || ogTagValue.isEmpty) {
          // Title fallback
          ogTagValue = document.head.getElementsByTagName("title")[0]?.text;
        }
        linkPreviewTitle = ogTagValue;
      } else if (ogTagName == 'description') {
        linkPreviewDescription = ogTagValue;
      } else if (ogTagName == 'image') {
        if (ogTagValue == null || ogTagValue.isEmpty) {
          // Image fallback
          var imgElements = document.body.getElementsByTagName("img");
          if (imgElements != null && imgElements.isNotEmpty)
            ogTagValue = imgElements?.first?.attributes["src"];
        }
        linkPreviewImageUrl = ogTagValue;
      } else if (ogTagName == 'site_name') {
        linkPreviewSiteName = ogTagValue;
      }
    });

    // This is the minimum required for a LinkPreview
    bool hasTitle = linkPreviewTitle != null && linkPreviewSiteName != null;

    if (!hasTitle) throw EmptyLinkToPreview(link);

    return LinkPreview(
        title: linkPreviewTitle,
        description: linkPreviewDescription,
        imageUrl: linkPreviewImageUrl,
        faviconUrl: linkPreviewFaviconUrl,
        domainUrl: linkPreviewDomainUrl,
        siteName: linkPreviewSiteName,
        url: link);
  }

  String _getLinkPreviewFaviconUrl(Document document) {
    var faviconElement = document.querySelector("link[rel*='shortcut icon']");

    String linkPreviewFaviconUrl =
        faviconElement != null ? faviconElement.attributes['href'] : null;

    if (linkPreviewFaviconUrl == null) {
      var shortcutIconElement = document.querySelector("link[rel*='icon']");
      if (shortcutIconElement != null) {
        linkPreviewFaviconUrl = shortcutIconElement?.attributes['href'];
      }
    }

    if (linkPreviewFaviconUrl != null)
      linkPreviewFaviconUrl = _normaliseLink(linkPreviewFaviconUrl);

    return linkPreviewFaviconUrl;
  }

  String _normaliseLink(String link) {
    if (link.startsWith('http') || link.startsWith('https')) {
      return link;
    } else if (link.startsWith('//')) {
      return 'http:$link';
    }

    return 'http://${link}';
  }

  String getProxiedLink(String link) {
    return '$_trustedProxyUrl?$link';
  }

  void _checkResponseIsOk(HttpieBaseResponse response) {
    if (response.isOk()) return;
    throw HttpieRequestError(response);
  }
}

class InvalidLinkToPreview implements Exception {
  String link;

  InvalidLinkToPreview(this.link);

  String toString() =>
      'InvalidLinkToPreview: $link is not a valid link to preview.';
}

class EmptyLinkToPreview implements Exception {
  String link;

  EmptyLinkToPreview(this.link);

  String toString() =>
      'EmptyLinkToPreview: $link was empty, could not be previewed.';
}
