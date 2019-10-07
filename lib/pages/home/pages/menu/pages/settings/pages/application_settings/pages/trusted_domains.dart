import 'package:Okuna/provider.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/toast.dart';
import 'package:Okuna/services/user_preferences.dart';
import 'package:Okuna/widgets/alerts/button_alert.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/icon_button.dart';
import 'package:Okuna/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Okuna/widgets/page_scaffold.dart';
import 'package:Okuna/widgets/search_bar.dart';
import 'package:Okuna/widgets/theming/actionable_smart_text.dart';
import 'package:Okuna/widgets/theming/primary_color_container.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBTrustedDomainsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OBTrustedDomainsPageState();
  }
}

class OBTrustedDomainsPageState extends State<OBTrustedDomainsPage> {
  LocalizationService _localizationService;
  UserPreferencesService _preferencesService;
  ToastService _toastService;

  GlobalKey<RefreshIndicatorState> _listRefreshIndicatorKey = GlobalKey();
  CancelableOperation _refreshOperation;

  List<String> _trustedDomains;
  List<String> _searchResults;
  String _searchQuery;
  bool _hasSearch;
  bool _needsBootstrap;
  bool _refreshInProgress;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _hasSearch = false;
    _searchQuery = '';
    _trustedDomains = [];
    _searchResults = [];
    _refreshInProgress = true;
  }

  void _bootstrap() async {
    Future.delayed(Duration(),
        () async => await _listRefreshIndicatorKey.currentState.show());
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var provider = OpenbookProvider.of(context);
      _localizationService = provider.localizationService;
      _preferencesService = provider.userPreferencesService;
      _toastService = provider.toastService;
      _bootstrap();
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: _localizationService.application_settings__trusted_domains_title,
      ),
      child: OBPrimaryColorContainer(
        child: _buildSettings(),
      ),
    );
  }

  Widget _buildSettings() {
    return Column(
      children: <Widget>[
        OBSearchBar(
          onSearch: _onSearch,
          hintText: _localizationService.user_search__list_search_text(
              _localizationService
                  .application_settings__trusted_domains_resource),
        ),
        Expanded(
          child: RefreshIndicator(
            key: _listRefreshIndicatorKey,
            child: SingleChildScrollView(
              child: _buildList(),
            ),
            onRefresh: _refreshTrustedDomains,
          ),
        ),
      ],
    );
  }

  Widget _buildList() {
    List<Widget> children = [];

    if (_hasSearch) {
      if (_searchResults.isNotEmpty || _refreshInProgress) {
        children.addAll(_buildListItems(_searchResults));
      } else {
        children.add(_buildNoSearchResults());
      }
    } else {
      if (_trustedDomains.isNotEmpty || _refreshInProgress) {
        children.addAll(_buildListItems(_trustedDomains));
      } else {
        children.add(_buildNoList());
      }
    }

    return Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 40),
        child: Column(children: children));
  }

  List<Widget> _buildListItems(List<String> items) {
    List<Widget> list = [];

    for (var domain in items) {
      list.add(ListTile(
        title: OBText(domain),
        trailing: OBIconButton(
          OBIcons.remove,
          onPressed: () => _deleteDomain(domain),
        ),
      ));
    }

    return list;
  }

  Widget _buildNoList() {
    return OBButtonAlert(
      text: _localizationService.user_search__list_no_results_found(
          _localizationService.application_settings__trusted_domains_resource),
      onPressed: _refreshTrustedDomains,
      buttonText: _localizationService.user_search__list_refresh_text,
      buttonIcon: OBIcons.refresh,
      assetImage: 'assets/images/stickers/perplexed-owl.png',
    );
  }

  Widget _buildNoSearchResults() {
    return ListTile(
      leading: const OBIcon(OBIcons.sad),
      title: OBText(
        _localizationService.user_search__no_results_for(_searchQuery),
      ),
    );
  }

  void _deleteDomain(String domain) async {
    bool wasDeleted = await _preferencesService.setAskToConfirmOpenUrl(true,
        hostAsString: domain);

    if (wasDeleted) {
      setState(() {
        _trustedDomains.remove(domain);
      });
    } else {
      _toastService.error(
          message:
              _localizationService.application_settings__delete_domain_failure,
          context: context);
    }
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _searchResults = _trustedDomains
          .where((domain) => domain.contains(_searchQuery))
          .toList();
      _hasSearch = query.isNotEmpty;
    });
  }

  void _setList(List<String> trustedDomains) {
    setState(() {
      _trustedDomains = trustedDomains.toList();
      _trustedDomains.sort((a, b) => a.compareTo(b));
      _onSearch(_searchQuery);
    });
  }

  void _setRefreshInProgress(bool refreshInProgress) {
    setState(() {
      _refreshInProgress = refreshInProgress;
    });
  }

  Future _refreshTrustedDomains() async {
    if (_refreshOperation != null) {
      _refreshOperation.cancel();
    }
    _setRefreshInProgress(true);

    _refreshOperation =
        CancelableOperation.fromFuture(_preferencesService.getTrustedDomains());
    List<String> trustedDomains = await _refreshOperation.value;

    _setList(trustedDomains);

    _setRefreshInProgress(false);
    _refreshOperation = null;
  }
}
