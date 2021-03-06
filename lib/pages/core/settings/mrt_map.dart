import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:smartmove/models/theme_enum.dart';
import 'package:smartmove/pages/core/travel/themes/travel_back_button.dart';
import 'package:smartmove/pages/core/travel/themes/values.dart';
import 'package:smartmove/theme.dart';

class MRTMapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = ThemeService.getTheme(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: PhotoView(
              minScale: PhotoViewComputedScale.contained * 1.4,
              maxScale: PhotoViewComputedScale.covered * 2.8,
              initialScale: PhotoViewComputedScale.covered * 0.35,
              enableRotation: true,
              backgroundDecoration: BoxDecoration(
                color: theme == ThemeEnum.dark
                    ? Colors.black
                    : Theme.of(context).scaffoldBackgroundColor,
              ),
              imageProvider: theme == ThemeEnum.dark
                  ? AssetImage("assets/mrt/mrt-dark.png")
                  : AssetImage("assets/mrt/mrt-light.png"),
            ),
          ),
          Positioned(
            // adding safeArea padding
            top: MediaQuery.of(context).padding.top + Values.pageHorizontalPadding,
            left: Values.pageHorizontalPadding,
            child: TravelBackButton(x: true),
          ),
        ],
      ),
    );
  }
}
