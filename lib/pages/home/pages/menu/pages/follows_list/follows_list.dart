import 'package:Openbook/models/follows_list.dart';
import 'package:Openbook/pages/home/pages/menu/pages/follows_list/widgets/follows_list_header/follows_list_header.dart';
import 'package:Openbook/pages/home/pages/menu/pages/follows_list/widgets/follows_list_users.dart';
import 'package:Openbook/pages/home/pages/menu/pages/follows_lists/follows_lists.dart';
import 'package:Openbook/widgets/nav_bar.dart';
import 'package:Openbook/pages/home/pages/post/widgets/expanded_post_comment.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Openbook/services/httpie.dart';

class OBFollowsListPage extends StatefulWidget {
  final OnWantsToEditFollowsList onWantsToEditFollowsList;
  final OnWantsToSeeUserProfile onWantsToSeeUserProfile;
  final FollowsList followsList;

  OBFollowsListPage(this.followsList,
      {@required this.onWantsToEditFollowsList,
      @required this.onWantsToSeeUserProfile});

  @override
  State<OBFollowsListPage> createState() {
    return OBFollowsListPageState();
  }
}

class OBFollowsListPageState extends State<OBFollowsListPage> {
  UserService _userService;
  ToastService _toastService;

  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  bool _needsBootstrap;

  @override
  void initState() {
    super.initState();
    _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    _needsBootstrap = true;
  }

  @override
  Widget build(BuildContext context) {
    var provider = OpenbookProvider.of(context);
    _userService = provider.userService;
    _toastService = provider.toastService;

    if (_needsBootstrap) {
      _bootstrap();
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        navigationBar: OBMenuNavBar(
          trailing: GestureDetector(
            onTap: () {
              widget.onWantsToEditFollowsList(widget.followsList);
            },
            child: Text('Edit'),
          ),
        ),
        child: RefreshIndicator(
            key: _refreshIndicatorKey,
            child: Container(
              color: Colors.white,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    OBFollowsListHeader(widget.followsList),
                    Expanded(
                      child: OBFollowsListUsers(
                        widget.followsList,
                        onWantsToSeeUserProfile: widget.onWantsToSeeUserProfile,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            onRefresh: _refreshFollowsList));
  }

  void _bootstrap() async {
    await _refreshFollowsList();
  }

  Future<void> _refreshFollowsList() async {
    try {
      await _userService.getFollowsListWithId(widget.followsList.id);
    } on HttpieConnectionRefusedError catch (error) {
      _toastService.error(message: 'No internet connection', context: context);
    } catch (error) {
      _toastService.error(message: 'Unknown error', context: context);
      rethrow;
    }
  }
}
