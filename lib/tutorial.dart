import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:smartmove/app_localizations.dart';
import 'package:smartmove/common_widgets/page_view_model_template.dart';
import 'package:smartmove/common_widgets/route.dart';
import 'package:smartmove/common_widgets/text_styles.dart';
import 'package:smartmove/pages/core/travel/location_permission.dart';
import 'package:smartmove/permission.dart';
import 'package:smartmove/splashview.dart';

class Tutorial extends StatelessWidget {
  PageViewModel addTaskTutorial(BuildContext context) {
    return pageViewModelTemplate(
      context,
      AppLocalizations.of(context).translate('tutorial1'),
      AppLocalizations.of(context).translate('tutorial2'),
      Colors.white,
      imageUrl: 'assets/onboard/add_edit.png',
    );
  }

  PageViewModel cardTutorial(BuildContext context) {
    return pageViewModelTemplate(
      context,
      AppLocalizations.of(context).translate('tutorial3'),
      AppLocalizations.of(context).translate('tutorial4'),
      Colors.white,
      imageUrl: 'assets/onboard/task_card.png',
    );
  }

  PageViewModel timingTutorial(BuildContext context) {
    return pageViewModelTemplate(
      context,
      AppLocalizations.of(context).translate('tutorial5'),
      AppLocalizations.of(context).translate('tutorial6'),
      Colors.white,
      imageUrl: 'assets/onboard/arrival-timings.png',
    );
  }

  PageViewModel serviceTileTutorial(BuildContext context) {
    return pageViewModelTemplate(
      context,
      AppLocalizations.of(context).translate('tutorial7'),
      AppLocalizations.of(context).translate('tutorial8'),
      Colors.white,
      imageUrl: 'assets/onboard/service-tile.png',
    );
  }

  /*PageViewModel favorites1(BuildContext context) {
    return pageViewModelTemplate(
      context,
      AppLocalizations.of(context).translate('tutorial5'),
      AppLocalizations.of(context).translate('tutorial6'),
      Colors.white,
      imageUrl: 'assets/onboard/favorites.png',
    );
  }*/

  ///todo: consider adding if search is added?
  /*PageViewModel search1(BuildContext context) {
    return pageViewModelTemplate(
      context,
      "Search for bus stops ...",
      "and view information about them.",
      Colors.white,
      imageUrl: 'assets/onboard/search.png',
    );
  }*/

  PageViewModel more(BuildContext context) {
    return pageViewModelTemplate(
      context,
      AppLocalizations.of(context).translate('tutorial9'),
      AppLocalizations.of(context).translate('tutorial10'),
      Color(0xFF000000),
      imageUrl: 'assets/onboard/mrt.png',
      dark: true,
    );
  }



  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        addTaskTutorial(context),
        cardTutorial(context),
        timingTutorial(context),
        serviceTileTutorial(context),
        // requestLocation(context),
        //favorites1(context),
        //search1(context),
        more(context),
      ],
      onDone: () => _finish(context),
      done: Text(AppLocalizations.of(context).translate('tasks_complete'), style: doneButtonTextStyle(context)),
      showSkipButton: true,
      skip: Text(AppLocalizations.of(context).translate('dismiss'), style: buttonTextStyle(context)),
      next: Text(AppLocalizations.of(context).translate('skip'), style: buttonTextStyle(context)),
      onSkip: () => _finish(context),
      freeze: false,
    );
  }

  _finish(context) async {
    final bool status = await LocationPermsProvider.getPermStatus();

    if (status == true)
      Routing.openFullScreenDialog(context, SplashView());
    else
      Routing.openReplacementRoute(context, PermissionRoute());
  }
}
