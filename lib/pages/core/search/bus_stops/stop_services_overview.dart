import 'package:flutter/material.dart';
import 'package:smartmove/common_widgets/route.dart';
import 'package:smartmove/pages/core/search/service/service_page.dart';

class StopServicesOverview extends StatelessWidget {
  final List services;
  StopServicesOverview({this.services});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: <Widget>[for (var stop in services) serviceContainer(context, stop)],
    );
  }

  Widget serviceContainer(BuildContext context, String stop) => InkWell(
    borderRadius: BorderRadius.circular(5),
    onTap: () => Routing.openRoute(context, ServicePage(service: stop,)),
    child: Container(
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        // color: Colors.green,
        border: Border.all(
          width: 1,
          color: Colors.green,
        ),
      ),
      child: Text(
        stop,
        // style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
        style: Theme.of(context).textTheme.headline1.copyWith(
          color: Colors.green,
        ),
      ),
    ),
  );
}
