import 'package:fluent_ui/fluent_ui.dart';

class FavButtonWrapper extends StatelessWidget {
  const FavButtonWrapper({
    super.key,
    required this.child,
    required this.icon,
    this.onTap,
  });
  final Widget child;
  final IconData icon;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          bottom: MediaQuery.of(context).size.height,
          right: 10,
          child: IconButton(
            icon: Icon(icon),
            onPressed: onTap,
            style: ButtonStyle(
              iconSize: ButtonState.all(20),
              padding: ButtonState.all(const EdgeInsets.all(20)),
              shape: ButtonState.all(const CircleBorder()),
              backgroundColor: ButtonState.all(Colors.orange),
              foregroundColor: ButtonState.all(Colors.white),
              shadowColor: ButtonState.all(Colors.blue),
            ),
          ),
        ),
      ],
    );
  }
}
