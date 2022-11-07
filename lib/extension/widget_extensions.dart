import 'package:flutter/cupertino.dart';

extension SizeShortcut on int {
  Widget get wSpace => SizedBox(width: toDouble());

  Widget get hSpace => SizedBox(height: toDouble());
}
