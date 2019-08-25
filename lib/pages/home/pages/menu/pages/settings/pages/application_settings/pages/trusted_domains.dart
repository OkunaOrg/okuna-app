import 'package:Okuna/provider.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/toast.dart';
import 'package:Okuna/services/user_preferences.dart';
import 'package:Okuna/widgets/fields/toggle_field.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/icon_button.dart';
import 'package:Okuna/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Okuna/widgets/page_scaffold.dart';
import 'package:Okuna/widgets/progress_indicator.dart';
import 'package:Okuna/widgets/search_bar.dart';
import 'package:Okuna/widgets/theming/actionable_smart_text.dart';
import 'package:Okuna/widgets/theming/primary_color_container.dart';
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

  bool _alwaysAsk;
  List<String> _trustedDomains;
  List<String> _searchResults;
  String _searchQuery;
  bool _hasSearch;
  bool _needsBootstrap;
  bool _bootstrapInProgress;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _bootstrapInProgress = true;
    _alwaysAsk = true;
    _hasSearch = false;
    _searchQuery = '';
    _trustedDomains = [];
    _searchResults = [];
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
        title: _localizationService
            .drawer__application_settings_trusted_domains_title,
      ),
      child: OBPrimaryColorContainer(
        child: _bootstrapInProgress
            ? _buildBootstrapInProgressIndicator()
            : _buildSettings(),
      ),
    );
  }

  Widget _buildBootstrapInProgressIndicator() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: const EdgeInsets.all(20),
              child: const OBProgressIndicator(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSettings() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: OBToggleField(
            key: Key('alwaysAsk'),
            value: _alwaysAsk,
            title:
                _localizationService.drawer__application_settings_ask_for_urls,
            onTap: _toggleAlwaysAsk,
            onChanged: _setAlwaysAsk,
          ),
        ),
        OBSearchBar(
          onSearch: _onSearch,
          hintText: _localizationService.user_search__list_search_text(
              _localizationService
                  .drawer__application_settings_trusted_domains_resource),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: _buildList(),
          ),
        ),
      ],
    );
  }

  Widget _buildList() {
    List<Widget> children = [];
    List<String> domainList = (_hasSearch ? _searchResults : _trustedDomains);

    for (var domain in domainList) {
      children.add(ListTile(
        title: OBText(domain),
        trailing: OBIconButton(
          OBIcons.remove,
          onPressed: () => _deleteDomain(domain),
        ),
      ));
    }

    return Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 40),
        child: Column(children: children));
  }

  void _deleteDomain(String domain) async {
    bool wasDeleted =
        await _preferencesService.setAskToConfirmOpenUrl(true, host: domain);

    if (wasDeleted) {
      setState(() {
        _trustedDomains.remove(domain);
      });
    } else {
      _toastService.error(
          message: _localizationService
              .drawer__application_settings_delete_domain_failure,
          context: context);
    }
  }

  void _toggleAlwaysAsk() {
    _setAlwaysAsk(!_alwaysAsk);
  }

  void _setAlwaysAsk(bool alwaysAsk) async {
    await _preferencesService.setAskToConfirmOpenUrl(alwaysAsk);

    setState(() {
      _alwaysAsk = alwaysAsk;
    });
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

  void _bootstrap() async {
    await Future.wait([_refreshAlwaysAsk(), _refreshTrustedDomains()]);
    _bootstrapInProgress = false;
  }

  Future _refreshAlwaysAsk() async {
    bool alwaysAsk = await _preferencesService.getAskToConfirmOpenUrl();

    setState(() {
      _alwaysAsk = alwaysAsk;
    });
  }

  Future _refreshTrustedDomains() async {
    List<String> trustedDomains = await _preferencesService.getTrustedDomains();

    setState(() {
      _trustedDomains = trustedDomains.toList();
      _trustedDomains.sort((a, b) => a.compareTo(b));
    });
  }
}
