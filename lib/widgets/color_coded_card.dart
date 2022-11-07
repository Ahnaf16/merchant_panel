// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fluent_ui/fluent_ui.dart';

class ColoredCardButton extends StatefulWidget {
  const ColoredCardButton({
    Key? key,
    required this.text,
    required this.title,
    required this.lineColor,
    this.color,
    this.lineWidth = 5,
    this.shrieked = false,
  }) : super(key: key);

  final String text;
  final String title;
  final double lineWidth;
  final Color lineColor;
  final Color? color;
  final bool shrieked;

  @override
  State<ColoredCardButton> createState() => _ColoredCardButtonState();
}

class _ColoredCardButtonState extends State<ColoredCardButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.shrieked ? 70 : 120,
      height: widget.shrieked ? 30 : 50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Card(
          backgroundColor: widget.color,
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.circular(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: widget.lineWidth,
                decoration: BoxDecoration(
                  color: widget.lineColor,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.shrieked ? widget.title : '${widget.title} : ',
                      style: TextStyle(fontSize: widget.shrieked ? 10 : null),
                    ),
                    if (!widget.shrieked) const SizedBox(height: 5),
                    Text(widget.text),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class ColoredCardButtonA extends StatefulWidget {
  const ColoredCardButtonA({
    super.key,
    required this.text,
    required this.title,
    required this.lineColor,
    required this.color,
    this.selected = false,
    this.onTap,
    //  this.shrieked,
  });

  final String text;
  final String title;
  final Color lineColor;
  final AccentColor color;
  final Function()? onTap;
  final bool selected;

  // final bool shrieked;
  @override
  State<ColoredCardButtonA> createState() => _ColoredCardButtonAState();
}

class _ColoredCardButtonAState extends State<ColoredCardButtonA> {
  bool isHovering = false;
  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: AnimatedContainer(
            duration: FluentTheme.of(context).fastAnimationDuration,
            height: 50,
            width: 120,
            decoration: BoxDecoration(
              color: widget.selected
                  ? widget.color
                      .defaultBrushFor(theme.brightness)
                      .withOpacity(.4)
                  : isHovering
                      ? widget.color
                          .defaultBrushFor(theme.brightness)
                          .withOpacity(.3)
                      : widget.color.withOpacity(.2),
              border: Border(
                left: BorderSide(
                    color: widget.lineColor,
                    width: widget.selected ? 6 : (isHovering ? 7 : 5)),
              ),
            ),
            child: Center(
              child: Text(
                '${widget.title}\n${widget.text}',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
