import 'package:flutter/cupertino.dart';

class TextAccountAutocompletionService {
  TextAccountAutocompletionResult checkTextForAutocompletion(TextEditingController textController) {
    int cursorPosition = textController.selection.baseOffset;

    if (cursorPosition >= 0) {
      String lastWord = _getWordBeforeCursor(textController.text, cursorPosition);

      if (lastWord.startsWith('@')) {
        String searchQuery = lastWord.substring(1);
        return TextAccountAutocompletionResult(
            isAutocompleting: true, autocompleteQuery: searchQuery);
      }
    }

    return TextAccountAutocompletionResult(isAutocompleting: false);
  }

  void autocompleteTextWithUsername(TextEditingController textController, String username){
    String text = textController.text;
    int cursorPosition = textController.selection.baseOffset;
    String lastWord = _getWordBeforeCursor(text, cursorPosition);

    if(!lastWord.startsWith('@')){
      throw 'Tried to autocomplete text with username without @';
    }

    var newText = text.substring(0, cursorPosition - lastWord.length) + '@$username' + text.substring(cursorPosition);
    var newSelection = TextSelection.collapsed(offset: cursorPosition - lastWord.length + username.length + 1);

    textController.value = TextEditingValue(text: newText, selection: newSelection);
  }

  String _getWordBeforeCursor(String text, int cursorPosition) {
    if (text.isNotEmpty) {
      var start = text.lastIndexOf(RegExp(r'\s'), cursorPosition - 1);
      return text.substring(start + 1, cursorPosition);
    } else {
      return text;
    }
  }
}

class TextAccountAutocompletionResult {
  final bool isAutocompleting;
  final String autocompleteQuery;

  TextAccountAutocompletionResult(
      {@required this.isAutocompleting, this.autocompleteQuery});
}
