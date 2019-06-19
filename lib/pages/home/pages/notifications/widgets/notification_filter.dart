import 'package:Openbook/models/notifications/notification.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class OBNotificationFilter extends StatelessWidget {
  final ValueChanged<NotificationFilter> onFilterChange;

  final NotificationFilter _filter;

  OBNotificationFilter(this._filter, this.onFilterChange);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: _buildIconWidgets(),
    );
  }

  List<Widget> _buildIconWidgets() {
    var widgets = <Widget>[
      OBIconButton(
        OBIcons.home,
        themeColor: (!_filter.hasFilter()
            ? OBIconThemeColor.primaryAccent
            : OBIconThemeColor.primaryText),
        onPressed: () => _toggleFilter(null),
      ),
      _createFilterButton([NotificationType.postReaction]),
      _createFilterButton(
          [NotificationType.postComment, NotificationType.postCommentReply]),
      _createFilterButton([NotificationType.connectionRequest, NotificationType.connectionConfirmed]),
      _createFilterButton([NotificationType.follow]),
      _createFilterButton([NotificationType.communityInvite]),
    ];

    return widgets;
  }

  OBIconButton _createFilterButton(List<NotificationType> types) {
    return OBIconButton(
      _getIcon(types[0]),
      themeColor: (_filter.hasFilter() && _filter.isActive(types[0])
          ? OBIconThemeColor.primaryAccent
          : OBIconThemeColor.primaryText),
      onPressed: () => _toggleFilter(types),
    );
  }

  OBIconData _getIcon(NotificationType value) {
    switch (value) {
      case NotificationType.postReaction:
        return OBIcons.react;
      case NotificationType.postComment:
      case NotificationType.postCommentReply:
        return OBIcons.comment;
      case NotificationType.connectionRequest:
      case NotificationType.connectionConfirmed:
      return OBIcons.connections;
      case NotificationType.follow:
        return OBIcons.follow;
      case NotificationType.communityInvite:
        return OBIcons.communityInvites;
      default:
        print("Unsupported notification type: $value");
        return OBIcons.close;
    }
  }

  void _toggleFilter(List<NotificationType> types) {
    if (types == null || types.isEmpty) {
      _filter.toggleAll();
    } else {
      _filter.toggle(types);
    }

    onFilterChange(_filter);
  }
}


class NotificationFilter {
  List<NotificationType> lastFilters = [];
  List<NotificationType> activeFilters = [];

  bool hasFilter() => activeFilters.isNotEmpty;

  bool isActive(NotificationType type) => !hasFilter() || activeFilters.contains(type);

  List<NotificationType> getActive() => activeFilters;

  void toggle(List<NotificationType> types) {
    for (var type in types) {
      if (activeFilters.contains(type)) {
        activeFilters.remove(type);
      } else {
        activeFilters.add(type);
      }
    }
  }

  void toggleAll() {
    if (activeFilters.isNotEmpty) {
      lastFilters.clear();
      lastFilters.addAll(activeFilters);
      activeFilters.clear();
    }
    else if (lastFilters.isNotEmpty) {
      activeFilters.addAll(lastFilters);
    }
  }
}
