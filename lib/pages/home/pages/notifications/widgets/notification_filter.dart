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
      _createFilterButton([
        NotificationType.postReaction,
        NotificationType.postCommentReaction
      ]),
      _createFilterButton([
        NotificationType.postComment,
        NotificationType.postCommentReply
      ]),
      _createFilterButton([
        NotificationType.connectionRequest,
        NotificationType.connectionConfirmed
      ]),
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

  OBIconData _getIcon(NotificationType type) {
    NotificationCategory category = NotificationFilter.getCategory(type);
    switch (category) {
      case NotificationCategory.Reaction:
        return OBIcons.react;
      case NotificationCategory.Comment:
        return OBIcons.comment;
      case NotificationCategory.Connection:
        return OBIcons.connections;
      case NotificationCategory.Follow:
        return OBIcons.follow;
      case NotificationCategory.Invite:
        return OBIcons.communityInvites;
      default:
        print("Unsupported notification type: $type");
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

enum NotificationCategory { Reaction, Comment, Connection, Follow, Invite }

class NotificationFilter {
  List<NotificationType> lastFilters = [];
  List<NotificationType> activeFilters = [];

  static NotificationCategory getCategory(NotificationType value) {
    switch (value) {
      case NotificationType.postReaction:
      case NotificationType.postCommentReaction:
        return NotificationCategory.Reaction;
      case NotificationType.postComment:
      case NotificationType.postCommentReply:
        return NotificationCategory.Comment;
      case NotificationType.connectionRequest:
      case NotificationType.connectionConfirmed:
        return NotificationCategory.Connection;
      case NotificationType.follow:
        return NotificationCategory.Follow;
      case NotificationType.communityInvite:
        return NotificationCategory.Invite;
      default:
        print("Unsupported notification type: $value");
        return null;
    }
  }

  bool hasFilter() => activeFilters.isNotEmpty;

  bool isActive(NotificationType type) =>
      !hasFilter() || activeFilters.contains(type);

  List<NotificationType> getActive() => activeFilters;

  List<NotificationCategory> getActiveCategories() {
    var list = <NotificationCategory>[];

    for (NotificationType type in activeFilters) {
      var category = getCategory(type);
      if (!list.contains(category)) {
        list.add(category);
      }
    }

    return list;
  }

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
    } else if (lastFilters.isNotEmpty) {
      activeFilters.addAll(lastFilters);
    }
  }
}
