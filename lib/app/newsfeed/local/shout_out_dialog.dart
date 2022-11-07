import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/extension/context_extensions.dart';
import 'package:merchant_panel/services/news_services.dart';
import 'package:merchant_panel/theme/theme.dart';
import '../../../theme/layout_manager.dart';

class ShoutOutDialog extends ConsumerWidget {
  const ShoutOutDialog({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = ref.read(layoutProvider(context));
    final isSmall = layout.isSmallScreen;
    final newsApi = ref.read(newsApiProvider.notifier);
    return ContentDialog(
      constraints: BoxConstraints(
        minWidth: isSmall ? double.infinity : context.width / 2,
      ),
      actions: [
        Button(
          style: hoveringButtonsStyle(Colors.warningPrimaryColor),
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Button(
          style: hoveringButtonsStyle(Colors.successPrimaryColor),
          child: const Text('Publish'),
          onPressed: () {
            newsApi.addShoutOut();
            Navigator.pop(context);
          },
        ),
      ],
      title: const Text('Add a Shout-Out'),
      content: TextBox(
        header: 'Shout Out',
        controller: newsApi.titleCtrl,
        decoration: boxDecoration,
        maxLines: null,
        minHeight: 100,
        suffixMode: OverlayVisibilityMode.editing,
        suffix: IconButton(
          icon: const Icon(FluentIcons.clear),
          onPressed: () {
            newsApi.titleCtrl.clear();
          },
        ),
      ),
    );
  }
}
