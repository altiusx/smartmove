import 'package:flutter/material.dart';
import 'package:smartmove/common_widgets/spacing.dart';
import 'package:smartmove/pages/core/travel/themes/tile_colors.dart';
import 'package:smartmove/pages/core/travel/themes/values.dart';

class TileButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function onTap;
  final List<Widget> children;
  TileButton({
    this.text,
    this.icon,
    this.onTap,
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    // if there is no icon, show text only,
    // otherwise show row
    Widget child = Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 15.0),
          child: Icon(
            icon,
            color: Theme.of(context).textTheme.bodyText1.color,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          flex: 5,
        )
      ],
    );

    return Container(
      // wrapping with container just to add margin
      margin: EdgeInsets.only(
        top: Values.marginBelowTitle / 2,
        bottom: Values.marginBelowTitle / 2,
      ),
      child: InkWell(
        child: Container(
          // these seem to need more padding, not entirely sure why
          padding: EdgeInsets.all(Values.marginBelowTitle),
          decoration: BoxDecoration(
            color: TileColors.busStopExpansionTile(context),
            borderRadius: BorderRadius.circular(Values.borderRadius),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              child,
              if (children != null) ...[
                Spacing(
                  height: 15,
                ),
                Wrap(
                  spacing: Values.marginBelowTitle,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: children,
                )
                // ...children,
              ],
            ],
          ),
        ),
        enableFeedback: true,
        borderRadius: BorderRadius.circular(Values.borderRadius),
        // only set the function if it's given, otherwise execute empty function
        onTap: () {
          if (onTap != null) onTap();
        },
      ),
    );
  }
}
