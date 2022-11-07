import 'package:fluent_ui/fluent_ui.dart';

extension ContextEx on BuildContext {
  double get height => MediaQuery.of(this).size.height;

  double get width => MediaQuery.of(this).size.width;

  Typography get textType => FluentTheme.of(this).typography;

  ThemeData get theme => FluentTheme.of(this);

  pushName(String routeName, [Object? arg]) {
    return Navigator.pushNamed(this, routeName, arguments: arg);
  }

  get pop => Navigator.pop(this);

  getDialog({
    required Widget child,
    bool barrierDismissible = true,
  }) {
    return showDialog(
      context: this,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return child;
      },
    );
  }
}
