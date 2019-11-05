import 'package:Okuna/models/post_preview_link_data.dart';
import 'package:Okuna/services/httpie.dart';
import 'package:Okuna/services/utils_service.dart';
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
  UtilsService _utilsService;

  String _trustedProxyUrl = '';

  static RegExp allowedProtocolsPattern =
      RegExp('http|https', caseSensitive: false);

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

  void setUtilsService(utilsService) {
    _utilsService = utilsService;
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
      Uri url = Uri.parse(matches.first);
      String urlMimeType = _utilsService.geFileNameMimeType(url.path);
      if (urlMimeType != null) {
        String urlFirstType = urlMimeType.split('/').first;
        if (urlFirstType != 'image' && urlFirstType != 'text') return null;
      }
      previewUrl = matches.first;
    }
    return previewUrl;
  }

  Future<LinkPreview> previewLink(String link) async {
    String normalisedLink = _normaliseLink(link);

    if (!_validationService.isUrl(normalisedLink.toLowerCase()))
      throw InvalidLinkToPreview(normalisedLink);

    bool appendAuthorizationHeader = _trustedProxyUrl.isNotEmpty;

    HttpieResponse response;

    if (!normalisedLink.startsWith('https://')) {
      try {
        String secureLink = normalisedLink.replaceFirst('http', 'https');
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

    String contentType = response.httpResponse.headers['content-type'];

    String mimeFirstType = contentType.split('/').first;

    LinkPreview result;

    if (mimeFirstType == 'image') {
      result = LinkPreview(image: response.httpResponse.bodyBytes);
    } else if (mimeFirstType == 'text') {
      result = _getLinkPreviewFromResponseBody(
          link: normalisedLink, responseBody: response.body);
    }

    return result;
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
    String linkPreviewFaviconUrl =
        _getLinkPreviewFaviconUrl(document, derivedFromLink: link);

    var openGraphMetaTags = document.head.querySelectorAll("[property*='og:']");

    openGraphMetaTags.forEach((openGraphMetaTag) {
      String ogTagName =
          openGraphMetaTag.attributes['property'].split("og:")[1];
      String ogTagValue = openGraphMetaTag.attributes['content'];

      if (ogTagName == 'title') {
        linkPreviewTitle = ogTagValue;
      } else if (ogTagName == 'description') {
        linkPreviewDescription = ogTagValue;
      } else if (ogTagName == 'image') {
        linkPreviewImageUrl = ogTagValue;
      } else if (ogTagName == 'site_name') {
        linkPreviewSiteName = ogTagValue;
      }
    });

    if (linkPreviewTitle == null) {
      // Fallback
      var titleElement = document.head.getElementsByTagName("title");
      if (titleElement != null && titleElement.isNotEmpty)
        linkPreviewTitle = titleElement[0]?.text;
    }

    if (linkPreviewImageUrl == null) {
      // Fallback
      var imgElements = document.getElementsByTagName("img");
      if (imgElements != null && imgElements.isNotEmpty) {
        try {
          linkPreviewImageUrl = imgElements.firstWhere((var imgElement) {
            String imgSrc = imgElement.attributes['src'];
            if (imgSrc == null) return false;
            return imgSrc.endsWith('jpg') ||
                imgSrc.endsWith('gif') ||
                imgSrc.endsWith('png');
          }).attributes["src"];
        } catch (error) {}
      }
    }

    if (linkPreviewImageUrl != null)
      linkPreviewImageUrl =
          _normaliseLink(linkPreviewImageUrl, derivedFromLink: link);

    if (linkPreviewFaviconUrl != null)
      linkPreviewFaviconUrl =
          _normaliseLink(linkPreviewFaviconUrl, derivedFromLink: link);

    print(linkPreviewImageUrl);

    return LinkPreview(
        title: linkPreviewTitle,
        description: linkPreviewDescription,
        imageUrl: linkPreviewImageUrl,
        faviconUrl: linkPreviewFaviconUrl,
        domainUrl: linkPreviewDomainUrl,
        siteName: linkPreviewSiteName,
        url: link);
  }

  String _getLinkPreviewFaviconUrl(Document document,
      {String derivedFromLink}) {
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
      linkPreviewFaviconUrl = _normaliseLink(linkPreviewFaviconUrl,
          derivedFromLink: derivedFromLink);

    return linkPreviewFaviconUrl;
  }

  String _normaliseLink(String link, {String derivedFromLink}) {
    if (link.startsWith(allowedProtocolsPattern)) {
      return link;
    } else if (link.startsWith('//')) {
      return 'http:$link';
    } else if (link.startsWith('/')) {
      // Absolute path
      Uri parsedDerivedFromLink = Uri.parse(derivedFromLink);
      return '${parsedDerivedFromLink.scheme}://${parsedDerivedFromLink.host}$link';
    } if(derivedFromLink != null){
      return derivedFromLink.endsWith('/')
          ? '$derivedFromLink$link'
          : '$derivedFromLink/$link';
    }

    return 'http://$link';
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
