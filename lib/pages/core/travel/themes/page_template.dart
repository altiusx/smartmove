import 'package:flutter/material.dart';
import 'travel_back_button.dart';
import 'values.dart';
import 'package:smartmove/common_widgets/extensions.dart';
import 'package:smartmove/common_widgets/spacing.dart';

class PageTemplate extends StatelessWidget {
  final List children;
  final bool showBackButton;
  final bool overscroll;

  PageTemplate({this.children, this.showBackButton = false, this.overscroll = true});

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return SafeArea(
      top: false,
      bottom: false,
      child: Container(
        padding: EdgeInsets.only(
          // top: statusBarHeight,
          left: Values.pageHorizontalPadding,
          right: Values.pageHorizontalPadding,
        ),
        child: CustomScrollView(
          slivers: <Widget>[
            Spacing(height: statusBarHeight).sliver(),
            if (showBackButton)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacing(height: Values.marginBelowTitle),
                  // Using wrap so it doesn't take 100% width
                  Wrap(children: <Widget>[TravelBackButton()]),

                  Spacing(height: Values.marginBelowTitle),
                ],
              ).sliverToBoxAdapter()
            else
              Spacing(height: 20).sliver(),

            ...children,

            // allow for some overscroll
            // this is a feature, not a bug
            if (overscroll) ...[
              Spacing(height: 240).sliver(),
            ]
          ],
        ),
      ),
    );
  }

  Widget scaffold() {
    return Scaffold(
      body: this,
    );
  }
}

///'package:flutter/src/widgets/framework.dart': Failed assertion: line 4345 pos 14: 'owner._debugCurrentBuildTarget == this': is not true.
// The relevant error-causing widget was:
//   Scaffold file:///Users/chrischoong96/AndroidStudioProjects/smartmove/lib/pages/core/travel/themes/page_template.dart:59:12