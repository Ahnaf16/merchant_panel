import 'package:fluent_ui/fluent_ui.dart';

class PageButtons extends StatelessWidget {
  const PageButtons({
    Key? key,
    required this.next,
    required this.previous,
  }) : super(key: key);

  final Function()? next;
  final Function()? previous;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: previous,
          child: const Text('Previous'),
        ),
        const SizedBox(width: 10),
        OutlinedButton(
          onPressed: next,
          child: const Text('Next'),
        ),
      ],
    );
  }
}
