import 'package:Okuna/models/post.dart';
import 'package:Okuna/models/post_link.dart';
import 'package:Okuna/models/post_preview_link_data.dart';
import 'package:Okuna/models/theme.dart';
import 'package:Okuna/services/theme.dart';
import 'package:Okuna/services/theme_value_parser.dart';
import 'package:Okuna/services/url_launcher.dart';
import 'package:Okuna/widgets/theming/secondary_text.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import '../../../../../provider.dart';
import '../../../../progress_indicator.dart';

class OBPostLinkPreview extends StatelessWidget {
  final LinkPreview previewLinkQueryData;
  final String previewLink;

  const OBPostLinkPreview({this.previewLinkQueryData, this.previewLink});

  @override
  Widget build(BuildContext context) {
    if (this.previewLinkQueryData == null) return SizedBox();

    // String previewLink = this.post.getPreviewLink();
    double screenWidth = MediaQuery.of(context).size.width;
    UrlLauncherService _urlLauncherService = OpenbookProvider.of(context).urlLauncherService;

    return GestureDetector(
      child:Column(
          children: <Widget>[
            _buildPreviewImage(screenWidth, this.previewLinkQueryData),
            _buildPreviewBar(this.previewLinkQueryData, context)
          ],
        ),
      onTap: (){
        _urlLauncherService.launchUrl(this.previewLink);
      },
    );
  }

  Widget _buildPreviewImage(double screenWidth, LinkPreview data) {

    if (data.imageUrl == null) return SizedBox();

    return TransitionToImage(
      width: screenWidth,
      fit: BoxFit.contain,
      alignment: Alignment.center,
      image: AdvancedNetworkImage(data.imageUrl,
          useDiskCache: false,
          fallbackAssetImage: 'assets/images/fallbacks/post-fallback.png',
          retryLimit: 0,
          timeoutDuration: const Duration(minutes: 1)),
      placeholder: Center(
        child: const OBProgressIndicator(),
      ),
      duration: const Duration(milliseconds: 300),
    );
  }

  Widget _buildPreviewBar(LinkPreview data, BuildContext context) {
    ThemeService themeService = OpenbookProvider.of(context).themeService;
    ThemeValueParserService themeValueParserService = OpenbookProvider.of(context).themeValueParserService;

    return StreamBuilder(
      stream: themeService.themeChange,
      initialData: themeService.getActiveTheme(),
      builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
        var theme = snapshot.data;
        Color primaryColor = themeValueParserService.parseColor(theme.primaryColor);
        final bool isDarkPrimaryColor = primaryColor.computeLuminance() < 0.179;
        Color backgroundColor = isDarkPrimaryColor
            ? Color.fromARGB(20, 255, 255, 255)
            : Color.fromARGB(10, 0, 0, 0);

        return DecoratedBox(
          decoration: BoxDecoration(color: backgroundColor),
          child: Padding(
            padding: EdgeInsets.only(left:20, right: 20, top: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Image(
                        width: 20.0,
                        height: 20.0,
                        image: AdvancedNetworkImage(data.faviconUrl, useDiskCache: true)
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    OBSecondaryText(
                      data.domainUrl.toUpperCase(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)
                    )
                  ],
                ),
                OBText(
                  data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                OBText(
                  data.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
