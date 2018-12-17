import 'package:Openbook/pages/home/modals/create_post/addons/post_addon.dart';
import 'package:flutter/cupertino.dart';

class OBAddonsManager {
  List<OBPostAddon> _enabledAddons = [];
  List<OBPostAddon> _availableAddons = [];
  List<OBPostAddon> _allAddons = [];
  Map<String, OBPostAddon> _allAddonsByIdentifier = {};

  void registerAddon(OBPostAddon addon) {
    _allAddons.add(addon);
    _availableAddons.add(addon);
    _allAddonsByIdentifier[addon.identifier] = addon;
  }

  List<Widget> buildAvailableAddonsButtons(BuildContext context) {
    return _availableAddons.map((OBPostAddon addon) {
      return addon.buildButton(
          context: context, enableAddon: () => _enableAddon(addon));
    });
  }

  List<Widget> buildEnabledAddonsPreviews(BuildContext context) {
    return _enabledAddons.map((OBPostAddon addon) {
      return addon.buildPreview(
          context: context, disableAddon: () => _disableAddon(addon));
    });
  }

  void handleRequestBody(Map<String, dynamic> body) {
    _enabledAddons.forEach((OBPostAddon enabledAddon) {
      enabledAddon.handleRequestBody(body: body);
    });
  }

  void _enableAddon(OBPostAddon addon) {
    List<String> excludedAddonIds = addon.getExcludedAddonsIdentifiers();
    _enabledAddons.removeWhere((OBPostAddon addon) {
      return excludedAddonIds.contains(addon.identifier);
    });
    _availableAddons.removeWhere((OBPostAddon addon) {
      return excludedAddonIds.contains(addon.identifier);
    });
    _enabledAddons.add(addon);
  }

  void _disableAddon(OBPostAddon addon) {
    _enabledAddons.remove(addon);
    List<String> excludedAddonIds = addon.getExcludedAddonsIdentifiers();
    excludedAddonIds.forEach((String excludedAddonId) {
      OBPostAddon excludedAddon = _allAddonsByIdentifier[excludedAddonIds];
      if (excludedAddon != null) {
        _availableAddons.add(excludedAddon);
      }
    });
  }
}
