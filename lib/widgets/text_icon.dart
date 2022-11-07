// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:fluent_ui/fluent_ui.dart';
import 'package:merchant_panel/extension/context_extensions.dart';
import 'package:merchant_panel/theme/theme.dart';

class TextIcon extends StatefulWidget {
  TextIcon({
    super.key,
    this.icon,
    this.action,
    this.text = '',
    this.iconSize,
    this.textStyle,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.actionAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
    this.showBorder = false,
    this.horizontalMargin = 8,
    this.verticalMargin = 5,
    this.onPressed,
    this.textAlign,
    this.hoverColor = const Color.fromARGB(255, 223, 223, 223),
    this.color,
    this.margin,
    this.actionDirection = Axis.horizontal,
  }) : label = Text(
          text,
          style: textStyle,
          textAlign: textAlign,
        );

  TextIcon.selectable({
    super.key,
    this.icon,
    this.action,
    this.text = '',
    this.iconSize,
    this.textStyle,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.actionAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
    this.showBorder = false,
    this.horizontalMargin = 8,
    this.verticalMargin = 5,
    this.onPressed,
    this.textAlign,
    this.hoverColor = const Color.fromARGB(255, 223, 223, 223),
    this.color,
    this.margin,
    this.actionDirection = Axis.horizontal,
  }) : label = SelectableText(
          text,
          style: textStyle,
          textAlign: textAlign,
        );

  final IconData? icon;
  final List<Widget>? action;
  final String text;
  final double? iconSize;
  final TextStyle? textStyle;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisAlignment actionAlignment;
  final MainAxisSize mainAxisSize;
  final bool showBorder;
  final double horizontalMargin;
  final double verticalMargin;
  final EdgeInsetsGeometry? margin;
  final Function()? onPressed;
  final TextAlign? textAlign;
  final Color hoverColor;
  final Color? color;
  final Widget label;
  final Axis actionDirection;

  @override
  State<TextIcon> createState() => _TextIconState();
}

class _TextIconState extends State<TextIcon> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: widget.onPressed == null
          ? null
          : (event) {
              setState(() {
                hovering = true;
              });
            },
      onExit: widget.onPressed == null
          ? null
          : (event) {
              setState(() {
                hovering = false;
              });
            },
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: context.theme.fastAnimationDuration,
          decoration: widget.showBorder
              ? boxDecoration.copyWith(
                  color: hovering ? widget.hoverColor : widget.color,
                )
              : BoxDecoration(
                  color: hovering ? widget.hoverColor : widget.color,
                  borderRadius: BorderRadius.circular(5),
                ),
          padding: EdgeInsets.symmetric(
            horizontal: widget.horizontalMargin,
            vertical: widget.verticalMargin,
          ),
          margin: widget.margin,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: widget.mainAxisAlignment,
                mainAxisSize: widget.mainAxisSize,
                children: [
                  if (widget.icon != null)
                    Icon(
                      widget.icon,
                      size: widget.iconSize,
                      color: widget.textStyle?.color,
                      semanticLabel: widget.text,
                    ),
                  if (widget.icon != null && widget.text.isNotEmpty)
                    const SizedBox(width: 10),
                  if (widget.actionDirection == Axis.horizontal)
                    Flexible(child: widget.label),
                  if (widget.action != null &&
                      widget.actionDirection == Axis.horizontal)
                    const SizedBox(width: 10),
                  if (widget.action != null &&
                      widget.actionDirection == Axis.vertical)
                    const SizedBox(height: 10),
                  if (widget.action != null &&
                      widget.actionDirection == Axis.vertical)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [widget.label, ...widget.action!],
                    ),
                  if (widget.action != null &&
                      widget.actionDirection == Axis.horizontal)
                    Row(
                      mainAxisAlignment: widget.actionAlignment,
                      children: widget.action!.toList(),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
