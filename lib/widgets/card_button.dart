import 'package:fluent_ui/fluent_ui.dart';

import '../theme/theme_manager.dart';

class CardButton extends StatelessWidget {
  const CardButton({
    Key? key,
    required this.title,
    required this.icon,
    this.onPressed,
    this.iconSize = 22,
    this.isExpanded = false,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final Function()? onPressed;
  final double iconSize;
  final bool isExpanded;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        height: isExpanded ? 60 : 100,
        width: isExpanded ? double.infinity : 200,
        child: Button(
          onPressed: onPressed,
          style: ButtonStyle(
            elevation:
                ButtonState.resolveWith((states) => states.isHovering ? 10 : 4),
            backgroundColor: ButtonState.resolveWith((states) {
              if (states.isHovering) {
                return Colors.grey[20];
              }
              if (states.isNone) {
                return Colors.grey[30];
              }
              return null;
            }),
            shape: ButtonState.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: isExpanded ? 20 : 0,
              ),
              Icon(
                icon,
                size: iconSize,
                color: Colors.blue,
              ),
              const SizedBox(width: 20),
              Flexible(
                child: Text(
                  title,
                  style: isExpanded ? null : textTheme(context).bodyLarge,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
