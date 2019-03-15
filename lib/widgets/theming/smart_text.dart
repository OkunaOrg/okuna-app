import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/theme.dart';
import 'package:Openbook/services/theme_value_parser.dart';
import 'package:Openbook/widgets/theming/text.dart';
export 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Based on https://github.com/knoxpo/flutter_smart_text_view

abstract class SmartTextElement {}

/// Represents an element containing a link
class LinkElement extends SmartTextElement {
  final String url;

  LinkElement(this.url);

  @override
  String toString() {
    return "LinkElement: $url";
  }
}

/// Represents an element containing a hastag
class HashTagElement extends SmartTextElement {
  final String tag;

  HashTagElement(this.tag);

  @override
  String toString() {
    return "HashTagElement: $tag";
  }
}

/// Represents an element containing a username
class UsernameElement extends SmartTextElement {
  final String username;

  UsernameElement(this.username);

  @override
  String toString() {
    return "UsernameElement: $username";
  }
}

/// Represents an element containing a community name
class CommunityNameElement extends SmartTextElement {
  final String communityName;

  CommunityNameElement(this.communityName);

  @override
  String toString() {
    return "CommunityNameElement: $communityName";
  }
}

/// Represents an element containing text
class TextElement extends SmartTextElement {
  final String text;

  TextElement(this.text);

  @override
  String toString() {
    return "TextElement: $text";
  }
}

final _linkRegex = RegExp(
    r"(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)",
    caseSensitive: false);
final _tagRegex = RegExp(r"\B#\w*[a-zA-Z]+\w*", caseSensitive: false);

final _usernameRegex = RegExp(r"^@[A-Za-z0-9_]{1,30}$", caseSensitive: false);

final _communityNameRegex =
    RegExp(r"^/c/[A-Za-z0-9_]{1,30}$", caseSensitive: false);

/// Turns [text] into a list of [SmartTextElement]
List<SmartTextElement> _smartify(String text) {
  final sentences = text.split('\n');
  List<SmartTextElement> span = [];
  sentences.forEach((sentence) {
    final words = sentence.split(' ');
    words.forEach((word) {
      if (_linkRegex.hasMatch(word)) {
        span.add(LinkElement(word));
      }
      /*else if (_tagRegex.hasMatch(word)) {
        span.add(HashTagElement(word));
      }*/
      else if (_usernameRegex.hasMatch(word)) {
        span.add(UsernameElement(word));
      } else if (_communityNameRegex.hasMatch(word)) {
        span.add(CommunityNameElement(word));
      } else {
        span.add(TextElement(word));
      }
      span.add(TextElement(' '));
    });
    if (words.isNotEmpty) {
      span.removeLast();
    }
    span.add(TextElement('\n'));
  });
  if (sentences.isNotEmpty) {
    span.removeLast();
  }
  return span;
}

/// Callback with URL to open
typedef StringCallback(String url);

/// Turns URLs into links
class OBSmartText extends StatelessWidget {
  /// Text to be linkified
  final String text;

  /// Style for non-link text
  final TextStyle style;

  /// Style of link text
  final TextStyle linkStyle;

  /// Style of HashTag text
  final TextStyle tagStyle;

  /// Callback for tapping a link
  final StringCallback onLinkTapped;

  /// Callback for tapping a link
  final StringCallback onTagTapped;

  /// Callback for tapping a link
  final StringCallback onUsernameTapped;

  /// Callback for tapping a link
  final StringCallback onCommunityNameTapped;

  final OBTextSize size;

  final TextOverflow overflow;

  const OBSmartText({
    Key key,
    this.text,
    this.overflow = TextOverflow.clip,
    this.style,
    this.linkStyle,
    this.tagStyle,
    this.onLinkTapped,
    this.onTagTapped,
    this.onUsernameTapped,
    this.onCommunityNameTapped,
    this.size = OBTextSize.medium,
  }) : super(key: key);

  /// Raw TextSpan builder for more control on the RichText
  TextSpan _buildTextSpan({
    String text,
    TextStyle style,
    TextStyle linkStyle,
    TextStyle tagStyle,
    TextStyle usernameStyle,
    TextStyle communityNameStyle,
    StringCallback onLinkTapped,
    StringCallback onTagTapped,
    StringCallback onUsernameTapped,
    StringCallback onCommunityNameTapped,
  }) {
    void _onOpen(String url) {
      if (onLinkTapped != null) {
        onLinkTapped(url);
      }
    }

    void _onTagTapped(String tag) {
      if (onTagTapped != null) {
        // Remove #
        String cleanedTag = tag.substring(1, tag.length).toLowerCase();
        onTagTapped(cleanedTag);
      }
    }

    void _onUsernameTapped(String username) {
      if (onUsernameTapped != null) {
        // Remove @
        String cleanedUsername =
            username.substring(1, username.length).toLowerCase();
        onUsernameTapped(cleanedUsername);
      }
    }

    void _onCommunityNameTapped(String communityName) {
      if (onCommunityNameTapped != null) {
        // Remove /c/
        String cleanedCommunityName =
            communityName.substring(3, communityName.length).toLowerCase();
        onCommunityNameTapped(cleanedCommunityName);
      }
    }

    final elements = _smartify(text);

    return TextSpan(
        children: elements.map<TextSpan>((element) {
      if (element is TextElement) {
        return TextSpan(
          text: element.text,
          style: style,
        );
      } else if (element is LinkElement) {
        return LinkTextSpan(
          text: element.url,
          style: linkStyle,
          onPressed: () => _onOpen(element.url),
        );
      } else if (element is HashTagElement) {
        return LinkTextSpan(
          text: element.tag,
          style: tagStyle,
          onPressed: () => _onTagTapped(element.tag),
        );
      } else if (element is UsernameElement) {
        return LinkTextSpan(
          text: element.username,
          style: usernameStyle,
          onPressed: () => _onUsernameTapped(element.username),
        );
      } else if (element is CommunityNameElement) {
        return LinkTextSpan(
          text: element.communityName,
          style: communityNameStyle,
          onPressed: () => _onCommunityNameTapped(element.communityName),
        );
      }
    }).toList());
  }

  @override
  Widget build(BuildContext context) {
    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
    ThemeService themeService = openbookProvider.themeService;
    ThemeValueParserService themeValueParserService =
        openbookProvider.themeValueParserService;

    double fontSize = OBText.getTextSize(size);

    return StreamBuilder(
      initialData: themeService.getActiveTheme(),
      stream: themeService.themeChange,
      builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
        OBTheme theme = snapshot.data;

        Color primaryTextColor =
            themeValueParserService.parseColor(theme.primaryTextColor);

        TextStyle textStyle =
            TextStyle(color: primaryTextColor, fontSize: fontSize);

        Color actionsForegroundColor = themeValueParserService
            .parseGradient(theme.primaryAccentColor)
            .colors[1];

        TextStyle smartItemsStyle = TextStyle(
          color: actionsForegroundColor,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        );

        return RichText(
          overflow: overflow,
          softWrap: true,
          text: _buildTextSpan(
              text: text,
              style: textStyle,
              linkStyle: smartItemsStyle,
              tagStyle: smartItemsStyle,
              communityNameStyle: smartItemsStyle,
              usernameStyle: smartItemsStyle,
              onLinkTapped: onLinkTapped,
              onTagTapped: onTagTapped,
              onCommunityNameTapped: onCommunityNameTapped,
              onUsernameTapped: onUsernameTapped),
        );
      },
    );
  }
}

class LinkTextSpan extends TextSpan {
  LinkTextSpan({TextStyle style, VoidCallback onPressed, String text})
      : super(
          style: style,
          text: text,
          recognizer: new TapGestureRecognizer()..onTap = onPressed,
        );
}
