import 'package:Openbook/models/follows_list.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/pages/menu/pages/follows_lists/follows_lists.dart';
import 'package:Openbook/pages/home/pages/menu/widgets/menu_nav_bar.dart';
import 'package:Openbook/widgets/follows_list_icon.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/tiles/user_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Openbook/services/httpie.dart';

class OBFollowsListPage extends StatefulWidget {
  final OnWantsToEditFollowsList onWantsToEditFollowsList;
  final FollowsList followsList;

  OBFollowsListPage(this.followsList,
      {@required this.onWantsToEditFollowsList});

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

    return StreamBuilder(
        stream: widget.followsList.updateChange,
        initialData: widget.followsList,
        builder: (BuildContext context, AsyncSnapshot<FollowsList> snapshot) {
          var followsList = snapshot.data;
          List<User> users = followsList.users?.users ?? [];

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
              child: Container(
                color: Colors.white,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              followsList.name,
                              style: TextStyle(
                                  fontSize: 30.0, fontWeight: FontWeight.bold),
                            ),
                            OBFollowsListEmoji(
                              followsListEmojiUrl: followsList.getEmojiImage(),
                              size: OBFollowsListEmojiSize.large,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text('Users', style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold)),
                      ),
                      Divider(),
                      Expanded(
                        child: RefreshIndicator(
                            key: _refreshIndicatorKey,
                            child: ListView.builder(
                                physics: AlwaysScrollableScrollPhysics(),
                                padding: EdgeInsets.all(0),
                                itemCount: users.length,
                                itemBuilder: (context, index) {
                                  var user = users[index];
                                  return OBUserTile(user);
                                }),
                            onRefresh: _refreshFollowsList),
                      ),
                    ],
                  ),
                ),
              ));
        });
  }

  void scrollToTop() {}

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
