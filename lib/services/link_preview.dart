import 'package:Okuna/models/post_preview_link_data.dart';
import 'package:Okuna/services/httpie.dart';
import 'package:Okuna/services/validation.dart';
import 'package:Okuna/widgets/theming/smart_text.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';

class LinkPreviewService {
  // We should retrieve these and cache them from the server once in a while
  static const allowedDomains = [
    'apple.com',
    'twitter.com',
    'google.com',
    'youtube.com',
    'youtu.be',
    'reddit.com',
    'wikipedia.org',
    'imgur.com',
    'okuna.support',
    'okuna.io',
    'hackblock.nl',
    'nasa.gov',
    'techcrunch.com',
    'golem.de',
    'sz.de',
    'www.theguardian.com',
  ];

  ValidationService _validationService;
  HttpieService _httpieService;

  String _trustedProxyUrl = '';

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
      String foundUrl = matches[0];
      String urlHost = Uri.parse(foundUrl).host;
      if (allowedDomains.contains(urlHost)) previewUrl = foundUrl;
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
        response = await _httpieService.get(_getProxiedLink(secureLink),
            appendAuthorizationToken: appendAuthorizationHeader);
        normalisedLink = secureLink;
      } on HttpieRequestError {
        response = await _httpieService.get(_getProxiedLink(normalisedLink),
            appendAuthorizationToken: appendAuthorizationHeader);
      }
    } else {
      response = await _httpieService.get(_getProxiedLink(normalisedLink),
          appendAuthorizationToken: appendAuthorizationHeader);
    }

    if (response.statusCode != 200) return null;

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
          if (imgElements.isNotEmpty)
            ogTagValue = imgElements?.first?.attributes["src"];
        }
        linkPreviewImageUrl = ogTagValue;
      } else if (ogTagName == 'site_name') {
        linkPreviewSiteName = ogTagValue;
      }
    });

    // This is the minimum required for a LinkPreview
    bool hasTitle = linkPreviewTitle != null && linkPreviewSiteName != null;

    if (!hasTitle) return null;

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

  String _getProxiedLink(String link) {
    return '$_trustedProxyUrl?$link';
  }
}

class InvalidLinkToPreview implements Exception {
  String link;

  InvalidLinkToPreview(this.link);

  String toString() =>
      'InvalidLinkToPreview: $link is not a valid link to preview.';
}
