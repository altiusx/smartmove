import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smartmove/common_widgets/extensions.dart';
import 'package:smartmove/common_widgets/spacing.dart';
import 'package:smartmove/common_widgets/title_text.dart';
import 'package:smartmove/pages/core/search/search_results_list.dart';
import 'package:smartmove/pages/core/search/search_text_box.dart';
import 'package:smartmove/common_widgets/strings.dart';
import 'package:smartmove/pages/core/search/providers/search_provider.dart';
import 'package:smartmove/pages/core/travel/themes/error_container.dart';
import 'package:smartmove/pages/core/travel/themes/page_template.dart';
import 'package:smartmove/pages/core/travel/themes/values.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SearchProvider searchProvider =
    Provider.of<SearchProvider>(context, listen: true);
    print('rebuild');

    return PageTemplate(
      children: [
        TitleText(
            title: Strings.searchTitle.toUpperCase(),
            iconData: FontAwesomeIcons.search)
            .sliverToBoxAdapter(),

        // search bar floats on top when you scroll down then scroll back up
        SliverPersistentHeader(
          pinned: false,
          floating: true,
          delegate: SearchBoxPersistentHeaderDelegate(
            minExtent: 70.0,
            maxExtent: 70.0,
          ),
        ),

        Spacing(height: Values.marginBelowTitle).sliver(),

        if (searchProvider.getNoStopsFoundValue()) ...[
          ErrorContainer(text: Strings.noStopsFound).sliverToBoxAdapter(),
          Spacing(height: Values.marginBelowTitle).sliver(),
        ],

        SearchResultsList().sliverToBoxAdapter()
      ],
    ).scaffold();
  }
}

class SearchBoxPersistentHeaderDelegate
    implements SliverPersistentHeaderDelegate {
  SearchBoxPersistentHeaderDelegate({
    this.minExtent,
    @required this.maxExtent,
  });
  final double minExtent;
  final double maxExtent;

  @override
  build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SearchTextBox();
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration => null;

  @override
  // TODO: implement showOnScreenConfiguration
  PersistentHeaderShowOnScreenConfiguration get showOnScreenConfiguration =>
      throw UnimplementedError();

  @override
  // TODO: implement vsync
  TickerProvider get vsync => throw UnimplementedError();
}
