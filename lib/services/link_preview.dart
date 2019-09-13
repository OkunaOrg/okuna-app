import 'package:Okuna/models/post_preview_link_data.dart';
import 'package:Okuna/services/httpie.dart';
import 'package:Okuna/services/validation.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';

class LinkPreviewService {
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

  Future<LinkPreview> previewLink(String link) async {
    if (!_validationService.isUrl(link)) throw InvalidLinkToPreview(link);

    // VERY DANGEROUS! PROXIES MUST BE A TRUSTED SOURCE AS THEY WILL RECEIVE
    // THE AUTHORIZATION TOKEN FROM THE USER
    bool appendAuthorizationHeader = _trustedProxyUrl.isNotEmpty;

    HttpieResponse response = await _httpieService.get(link,
        appendAuthorizationToken: appendAuthorizationHeader);

    String proxiedUrl = _trustedProxyUrl += link;

    return _getLinkPreviewFromResponseBody(
        link: proxiedUrl, responseBody: response.body);
  }

  LinkPreview _getLinkPreviewFromResponseBody(
      {@required String link, @required String responseBody}) {
    Document document = parser.parse(responseBody);

    // Assigned with iterated og tags
    String linkPreviewTitle;
    String linkPreviewDescription;
    String linkPreviewImageUrl;
    String linkPreviewDomainUrl = Uri.parse(link).host;
    // Assigned separately
    String linkPreviewFaviconUrl = _getLinkPreviewFaviconUrl(document);

    var openGraphMetaTags = document.head.querySelectorAll("[property*='og:']");

    openGraphMetaTags.forEach((openGraphMetaTag) {
      String ogTagName = openGraphMetaTag.attributes['property'];
      String ogTagValue = openGraphMetaTag.attributes['content'];

      if (ogTagName == 'title') {
        if (ogTagValue == null || ogTagValue.isEmpty) {
          // Title fallback
          ogTagValue = document.head.getElementsByTagName("title")[0].text;
        }

        linkPreviewTitle = ogTagValue;
      } else if (ogTagName == 'description') {
        linkPreviewDescription = ogTagValue;
      } else if (ogTagName == 'image') {
        if (ogTagValue == null || ogTagValue.isEmpty) {
          // Image fallback
          var imgElements = document.body.getElementsByTagName("img");
          if (imgElements.isNotEmpty)
            ogTagValue = imgElements.first.attributes["src"];
        }
        linkPreviewImageUrl = ogTagValue;
      }
    });

    return LinkPreview(
        title: linkPreviewTitle,
        description: linkPreviewDescription,
        imageUrl: linkPreviewImageUrl,
        faviconUrl: linkPreviewFaviconUrl,
        domainUrl: linkPreviewDomainUrl);
  }

  String _getLinkPreviewFaviconUrl(Document document) {
    var faviconElement = document.querySelector("link[rel*='icon']");
    String linkPreviewFaviconUrl = faviconElement.attributes['href'];
    if (linkPreviewFaviconUrl == null || linkPreviewFaviconUrl.isEmpty) {
      var shortcutIconElement =
          document.querySelector("link[rel*='shortcut icon']");
      linkPreviewFaviconUrl = shortcutIconElement.attributes['href'];
    }
    return linkPreviewFaviconUrl;
  }
}

class InvalidLinkToPreview implements Exception {
  String link;

  InvalidLinkToPreview(this.link);

  String toString() =>
      'InvalidLinkToPreview: $link is not a valid link to preview.';
}
