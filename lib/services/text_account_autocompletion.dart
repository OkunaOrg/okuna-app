import 'package:flutter/cupertino.dart';

class TextAccountAutocompletionService {
  TextAccountAutocompletionResult checkTextForAutocompletion(TextEditingController textController) {
    String lastWord = textController.text.replaceAll('\n', ' ').split(' ').last;
    int cursorPosition = textController.selection.baseOffset;

    if (lastWord.startsWith('@') && cursorPosition == textController.text.length) {
      String searchQuery = lastWord.substring(1);
      return TextAccountAutocompletionResult(
          isAutocompleting: true, autocompleteQuery: searchQuery);
    } else {
      return TextAccountAutocompletionResult(isAutocompleting: false);
    }
  }

  String autocompleteTextWithUsername(String text, String username){
    String lastWord = text.split(RegExp(r'\s')).last;

    if(!lastWord.startsWith('@')){
      throw 'Tried to autocomplete text with username without @';
    }

    return text.substring(0, text.length - lastWord.length) + '@$username ';
  }
}

class TextAccountAutocompletionResult {
  final bool isAutocompleting;
  final String autocompleteQuery;

  TextAccountAutocompletionResult(
      {@required this.isAutocompleting, this.autocompleteQuery});
}
