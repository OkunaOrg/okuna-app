import 'package:flutter/cupertino.dart';

class TextAccountAutocompletionService {
  TextAccountAutocompletionResult checkTextForAutocompletion(TextEditingController textController) {
    int cursorPosition = textController.selection.baseOffset;

    //FIXME(komposten): No need to split the full string when we can just find the first "\s" before the cursorPosition.
    if (cursorPosition >= 0) {
      String lastWord = textController.text
          .substring(0, cursorPosition)
          .replaceAll('\n', ' ')
          .split(' ')
          .last;

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

    //FIXME(komposten): No need to split the full string when we can just find the first "\s" before the cursorPosition.
    String lastWord = text.substring(0, cursorPosition).split(RegExp(r'\s')).last;

    if(!lastWord.startsWith('@')){
      throw 'Tried to autocomplete text with username without @';
    }

    var newText = text.substring(0, cursorPosition - lastWord.length) + '@$username' + text.substring(cursorPosition);
    var newSelection = TextSelection.collapsed(offset: cursorPosition - lastWord.length + username.length + 1);

    textController.value = TextEditingValue(text: newText, selection: newSelection);
  }
}

class TextAccountAutocompletionResult {
  final bool isAutocompleting;
  final String autocompleteQuery;

  TextAccountAutocompletionResult(
      {@required this.isAutocompleting, this.autocompleteQuery});
}
