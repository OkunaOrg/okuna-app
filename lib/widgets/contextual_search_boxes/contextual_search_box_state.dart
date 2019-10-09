import 'package:Okuna/models/community.dart';
import 'package:Okuna/models/user.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/text_account_autocompletion.dart';
import 'package:Okuna/widgets/contextual_search_boxes/contextual_account_search_box.dart';
import 'package:Okuna/widgets/contextual_search_boxes/contextual_community_search_box.dart';
import 'package:flutter/material.dart';

abstract class OBContextualSearchBoxState<T extends StatefulWidget>
    extends State<T> {
  TextAutocompletionService _textAutocompletionService;
  OBContextualAccountSearchBoxController _contextualAccountSearchBoxController;
  OBContextualCommunitySearchBoxController
      _contextualCommunitySearchBoxController;

  TextAutocompletionType _autocompletionType;

  TextEditingController _autocompleteTextController;

  bool isAutocompleting;

  @override
  void initState() {
    super.initState();
    _contextualAccountSearchBoxController =
        OBContextualAccountSearchBoxController();
    _contextualCommunitySearchBoxController =
        OBContextualCommunitySearchBoxController();
    isAutocompleting = false;
  }

  @override
  void dispose() {
    super.dispose();
    _autocompleteTextController?.removeListener(_checkForAutocomplete);
  }

  void bootstrap() {
    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
    _textAutocompletionService =
        openbookProvider.textAccountAutocompletionService;
  }

  void setAutocompleteTextController(TextEditingController textController) {
    _autocompleteTextController = textController;
    textController.addListener(_checkForAutocomplete);
  }

  Widget buildSearchBox() {
    if (!isAutocompleting) {
      throw 'There is no current autocompletion';
    }

    return _autocompletionType == TextAutocompletionType.account
        ? _buildAccountSearchBox()
        : _buildCommunitySearchBox();
  }

  Widget _buildAccountSearchBox() {
    return OBContextualAccountSearchBox(
      controller: _contextualAccountSearchBoxController,
      onPostParticipantPressed: _onAccountSearchBoxUserPressed,
      initialSearchQuery:
          _contextualAccountSearchBoxController.getLastSearchQuery(),
    );
  }

  Widget _buildCommunitySearchBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: OBContextualCommunitySearchBox(
        controller: _contextualCommunitySearchBoxController,
        onCommunityPressed: _onCommunitySearchBoxUserPressed,
        initialSearchQuery:
            _contextualCommunitySearchBoxController.getLastSearchQuery(),
      ),
    );
  }

  void _onAccountSearchBoxUserPressed(User user) {
    autocompleteFoundAccountUsername(user.username);
  }

  void _onCommunitySearchBoxUserPressed(Community community) {
    autocompleteFoundCommunityName(community.name);
  }

  void _checkForAutocomplete() {
    TextAutocompletionResult result = _textAutocompletionService
        .checkTextForAutocompletion(_autocompleteTextController);

    if (result.isAutocompleting) {
      debugLog('Wants to autocomplete with type ${result.type} searchQuery:' +
          result.autocompleteQuery);
      _setIsAutocompleting(true);
      _setAutocompletionType(result.type);
      result.type == TextAutocompletionType.account
          ? _contextualAccountSearchBoxController
              .search(result.autocompleteQuery)
          : _contextualCommunitySearchBoxController
              .search(result.autocompleteQuery);
    } else if (isAutocompleting) {
      debugLog('Finished autocompleting');
      _setIsAutocompleting(false);
    }
  }

  void autocompleteFoundAccountUsername(String foundAccountUsername) {
    if (!isAutocompleting) {
      debugLog(
          'Tried to autocomplete found account username but was not searching account');
      return;
    }

    debugLog('Autocompleting with username:$foundAccountUsername');
    setState(() {
      _textAutocompletionService.autocompleteTextWithUsername(
          _autocompleteTextController, foundAccountUsername);
    });
  }

  void autocompleteFoundCommunityName(String foundCommunityName) {
    if (!isAutocompleting) {
      debugLog(
          'Tried to autocomplete found community name but was not searching community');
      return;
    }

    debugLog('Autocompleting with name:$foundCommunityName');
    setState(() {
      _textAutocompletionService.autocompleteTextWithCommunityName(
          _autocompleteTextController, foundCommunityName);
    });
  }

  void _setIsAutocompleting(bool isSearchingAccount) {
    setState(() {
      isAutocompleting = isSearchingAccount;
    });
  }

  void _setAutocompletionType(TextAutocompletionType autocompletionType) {
    setState(() {
      _autocompletionType = autocompletionType;
    });
  }

  void setState(VoidCallback fn);

  void debugLog(String log) {
    debugPrint('ContextualSearchBoxStateMixin:$log');
  }
}
