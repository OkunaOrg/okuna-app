import 'package:Openbook/models/community.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:flutter/material.dart';

class OBCommunityActionMore extends StatelessWidget {
  final Community community;

  const OBCommunityActionMore(this.community);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: community.updateSubject,
      initialData: community,
      builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
        var community = snapshot.data;

        return IconButton(
          icon: const OBIcon(
            OBIcons.moreVertical,
            customSize: 30,
          ),
          onPressed: () {
            List<Widget> moreTiles = [];

            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return OBPrimaryColorContainer(
                    mainAxisSize: MainAxisSize.min,
                    child: Column(
                        mainAxisSize: MainAxisSize.min, children: moreTiles),
                  );
                });
          },
        );
      },
    );
  }
}
