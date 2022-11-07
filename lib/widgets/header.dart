import 'package:fluent_ui/fluent_ui.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
    this.title,
    this.commandBar,
    this.showLeading = true,
  }) : super(key: key);

  final String? title;
  final Widget? commandBar;
  final bool showLeading;

  @override
  Widget build(BuildContext context) {
    return PageHeader(
      title: Text(title ?? ''),
      leading: showLeading
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: IconButton(
                icon: const Icon(FluentIcons.back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          : null,
      commandBar: commandBar,
    );
  }
}
