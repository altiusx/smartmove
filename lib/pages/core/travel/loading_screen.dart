import 'package:flutter/material.dart';
import 'package:smartmove/pages/core/travel/themes/tile_colors.dart';
import 'package:smartmove/pages/core/travel/themes/values.dart';
import 'package:smartmove/common_widgets/strings.dart';

class LoadingText extends StatelessWidget {
  final String text;
  LoadingText({this.text = "Loading ..."});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Values.busStopTileHorizontalPadding,
        vertical: Values.busStopTileVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: TileColors.busStopExpansionTile(context),
        borderRadius: BorderRadius.circular(Values.borderRadius),
      ),
      child: Column(
        // shrinkWrap: true,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            text,
            style: Theme.of(context).textTheme.headline6.copyWith(
              fontSize: Values.em * 1.1,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            _getRandomMessage(),
            style: Theme.of(context).textTheme.bodyText2.copyWith(
              fontSize: Values.em * 0.8,
            ),
          ),
        ],
      ),
    );
  }

  _getRandomMessage() {
    // get a random message from the messages array
    return (Strings.messages.toList()..shuffle()).first;
  }
}
