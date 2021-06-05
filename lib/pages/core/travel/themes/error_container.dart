import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'values.dart';

class ErrorContainer extends StatelessWidget {
  final String text;

  ErrorContainer({@required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Values.busServiceTilePadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Values.borderRadius * 0.8),
        color: Theme
            .of(context)
            .errorColor
            .withOpacity(Values.containerOpacity),
      ),
      child: MarkdownBody(
        data: text,
        styleSheet: MarkdownStyleSheet(
          p: Theme
              .of(context)
              .textTheme
              .bodyText2
              .copyWith(
            color: Theme
                .of(context)
                .errorColor,
          ),
        ),
      ),
    );
  }
}