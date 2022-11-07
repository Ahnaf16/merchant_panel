// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:fluent_ui/fluent_ui.dart';

import 'package:merchant_panel/theme/theme.dart';

class KErrorWidget extends StatelessWidget {
  const KErrorWidget({
    Key? key,
    required this.error,
    required this.st,
    this.name = '',
    this.useLog = false,
  }) : super(key: key);
  final Object error;
  final StackTrace? st;
  final String name;
  final bool useLog;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: boxDecoration.copyWith(color: Colors.warningPrimaryColor),
          child: IconButton(
            icon: Icon(
              FluentIcons.bug_warning,
              size: 25,
              color: Colors.warningSecondaryColor,
            ),
            onPressed: () {
              useLog
                  ? log('error: $error\n stack: $st', name: name)
                  : debugPrint('[$name]\n error: $error\n stack: $st');
            },
          ),
        ),
        SelectableText('$name error: $error'),
      ],
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
    this.width = 200,
    this.height = 100,
  }) : super(key: key);
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: const Center(
        child: ProgressRing(),
      ),
    );
  }
}
