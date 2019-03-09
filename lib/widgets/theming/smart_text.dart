import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/theme.dart';
import 'package:Openbook/services/theme_value_parser.dart';
import 'package:Openbook/widgets/theming/text.dart';
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

final _usernameRegex = RegExp(r"\B@\w*[a-zA-Z_]+\w*", caseSensitive: false);

final _communityNameRegex =
    RegExp(r"\B/c/\w*[a-zA-Z_]+\w*", caseSensitive: false);

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
  final StringCallback onOpen;

  /// Callback for tapping a link
  final StringCallback onTagClick;

  /// Callback for tapping a link
  final StringCallback onUsernameClick;

  /// Callback for tapping a link
  final StringCallback onCommunityNameClick;

  final OBTextSize size;

  const OBSmartText({
    Key key,
    this.text,
    this.style,
    this.linkStyle,
    this.tagStyle,
    this.onOpen,
    this.onTagClick,
    this.onUsernameClick,
    this.onCommunityNameClick,
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
    StringCallback onOpen,
    StringCallback onTagClick,
    StringCallback onUsernameClick,
    StringCallback onCommunityNameClick,
  }) {
    void _onOpen(String url) {
      if (onOpen != null) {
        onOpen(url);
      }
    }

    void _onTagClick(String url) {
      if (onTagClick != null) {
        onTagClick(url);
      }
    }

    void _onUsernameClick(String url) {
      if (onUsernameClick != null) {
        onUsernameClick(url);
      }
    }

    void _onCommunityNameClick(String url) {
      if (onCommunityNameClick != null) {
        onCommunityNameClick(url);
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
          onPressed: () => _onTagClick(element.tag),
        );
      } else if (element is UsernameElement) {
        return LinkTextSpan(
          text: element.username,
          style: usernameStyle,
          onPressed: () => _onUsernameClick(element.username),
        );
      } else if (element is CommunityNameElement) {
        return LinkTextSpan(
          text: element.communityName,
          style: communityNameStyle,
          onPressed: () => _onCommunityNameClick(element.communityName),
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

        TextStyle textStyle = TextStyle(
            color: themeValueParserService.parseColor(theme.primaryTextColor),
            fontSize: fontSize);

        TextStyle smartItemsStyle = TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..shader = themeValueParserService
                  .parseGradient(theme.primaryAccentColor)
                  .createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)));

        return RichText(
          softWrap: true,
          text: _buildTextSpan(
              text: text,
              style: textStyle,
              linkStyle: smartItemsStyle,
              tagStyle: smartItemsStyle,
              communityNameStyle: smartItemsStyle,
              usernameStyle: smartItemsStyle,
              onOpen: onOpen,
              onTagClick: onTagClick,
              onCommunityNameClick: onCommunityNameClick,
              onUsernameClick: onUsernameClick),
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
