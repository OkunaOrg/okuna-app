import 'package:Okuna/services/validation.dart';
import 'package:flutter/cupertino.dart';

class TextAutocompletionService {
  ValidationService _validationService;

  void setValidationService(validationService) {
    _validationService = validationService;
  }

  TextAutocompletionResult checkTextForAutocompletion(
      TextEditingController textController) {
    int cursorPosition = textController.selection.baseOffset;

    if (cursorPosition >= 1) {
      String lastWord =
          _getWordBeforeCursor(textController.text, cursorPosition);

      if (lastWord.startsWith('@')) {
        String searchQuery = lastWord.substring(1);
        return TextAutocompletionResult(
            isAutocompleting: true,
            autocompleteQuery: searchQuery,
            type: TextAutocompletionType.account);
      } else if (lastWord.startsWith('c/')) {
        String searchQuery = lastWord.substring(3);
        return TextAutocompletionResult(
            isAutocompleting: true,
            autocompleteQuery: searchQuery,
            type: TextAutocompletionType.community);
      } else if (lastWord.startsWith('#') && lastWord.length > 1 &&
          _validationService.isPostTextContainingValidHashtags(lastWord)) {
        String searchQuery = lastWord.substring(1);
        return TextAutocompletionResult(
            isAutocompleting: true,
            autocompleteQuery: searchQuery,
            type: TextAutocompletionType.hashtag);
      }
    }

    return TextAutocompletionResult(isAutocompleting: false);
  }

  void autocompleteTextWithUsername(
      TextEditingController textController, String username) {
    _autocompleteText(textController, username, '@',
        () => throw 'Tried to autocomplete text with username without @');
  }

  void autocompleteTextWithHashtagName(
      TextEditingController textController, String hashtag) {
    _autocompleteText(textController, hashtag, '#',
        () => throw 'Tried to autocomplete text with hashtag without #');
  }

  void autocompleteTextWithCommunityName(
      TextEditingController textController, String communityName) {
    _autocompleteText(textController, communityName, 'c/',
        () => throw 'Tried to autocomplete text with community name without c/');
  }

  String _getWordBeforeCursor(String text, int cursorPosition) {
    if (text.isNotEmpty) {
      var start = text.lastIndexOf(RegExp(r'\s'), cursorPosition - 1);
      return text.substring(start + 1, cursorPosition);
    } else {
      return text;
    }
  }

  void _autocompleteText(TextEditingController textController, String value,
      String prefix, VoidCallback onPrefixMissing) {
    String text = textController.text;
    int cursorPosition = textController.selection.baseOffset;
    String lastWord = _getWordBeforeCursor(text, cursorPosition);

    if (!lastWord.startsWith(prefix)) {
      onPrefixMissing();
    }

    var newTextStart =
        text.substring(0, cursorPosition - lastWord.length) + '$prefix$value ';
    var newTextEnd = text.substring(cursorPosition);
    var newSelection = TextSelection.collapsed(offset: newTextStart.length);

    textController.value = TextEditingValue(
        text: newTextStart + newTextEnd, selection: newSelection);
  }
}

class TextAutocompletionResult {
  final bool isAutocompleting;
  final String autocompleteQuery;
  final TextAutocompletionType type;

  TextAutocompletionResult(
      {@required this.isAutocompleting, this.type, this.autocompleteQuery});
}

enum TextAutocompletionType { account, community, hashtag }
