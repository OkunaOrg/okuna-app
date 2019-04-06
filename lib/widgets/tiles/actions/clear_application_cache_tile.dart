import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:Openbook/widgets/tiles/loading_tile.dart';
import 'package:flutter/material.dart';

class OBClearApplicationCacheTile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OBClearApplicationCacheTileState();
  }
}

class OBClearApplicationCacheTileState
    extends State<OBClearApplicationCacheTile> {
  bool _inProgress;
  ToastService _toastService;

  @override
  initState() {
    super.initState();
    _inProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    return OBLoadingTile(
      leading: OBIcon(OBIcons.clear),
      title: OBText('Clear cache'),
      subtitle: OBSecondaryText('Clear cached posts, accounts, images & more.'),
      isLoading: _inProgress,
      onTap: _clearApplicationCache,
    );
  }

  Future _clearApplicationCache() async {
    _setInProgress(true);

    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
    try {
      await openbookProvider.userService.clearCache();
      openbookProvider.toastService
          .success(message: 'Cleared cache successfully', context: context);
    } catch (error) {
      openbookProvider.toastService
          .error(message: 'Could not clear cache', context: context);
      rethrow;
    } finally {
      _setInProgress(false);
    }
  }

  void _setInProgress(bool inProgress) {
    setState(() {
      this._inProgress = inProgress;
    });
  }
}
