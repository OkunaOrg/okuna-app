import 'package:flutter/cupertino.dart';

class TextAccountAutocompletionService {
  TextAccountAutocompletionResult checkTextForAutocompletion(String text) {
    String lastWord = text.split(' ').last;

    if (lastWord.startsWith('@')) {
      String searchQuery = lastWord.substring(1);
      return TextAccountAutocompletionResult(
          isAutocompleting: true, autocompleteQuery: searchQuery);
    } else {
      return TextAccountAutocompletionResult(isAutocompleting: false);
    }
  }

  String autocompleteTextWithUsername(String text, String username){
    String lastWord = text.split(' ').last;

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
