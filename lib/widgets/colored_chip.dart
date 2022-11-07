import 'package:fluent_ui/fluent_ui.dart';

class ColoredChip extends StatefulWidget {
  const ColoredChip({
    super.key,
    this.backgroundColor,
    this.hoverColor,
    this.selectedColor,
    this.leading,
    required this.text,
    this.trailing,
    this.onTap,
    this.selected = false,
  });

  final Color? backgroundColor;
  final Color? hoverColor;
  final Color? selectedColor;
  final Widget? leading;
  final Widget text;
  final Widget? trailing;
  final Function()? onTap;
  final bool selected;

  @override
  State<ColoredChip> createState() => _ColoredChipState();
}

class _ColoredChipState extends State<ColoredChip> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    Color bg = widget.backgroundColor ?? Colors.grey[30];
    Color hover = widget.hoverColor ?? Colors.grey[50];
    Color selectedColor = widget.selectedColor ?? Colors.grey[60];
    return MouseRegion(
      onEnter: (v) {
        setState(() {
          isHovering = true;
        });
      },
      onExit: (v) {
        setState(() {
          isHovering = false;
        });
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          duration: FluentTheme.of(context).fastAnimationDuration,
          decoration: BoxDecoration(
            color: widget.selected ? selectedColor : (isHovering ? hover : bg),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.leading != null) widget.leading!,
              widget.text,
              if (widget.trailing != null) widget.trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
