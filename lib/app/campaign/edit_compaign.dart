import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/widgets/body_base.dart';

class EditCampaign extends ConsumerWidget {
  const EditCampaign({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScaffoldPage(
      header: PageHeader(
        commandBar: FilledButton(
          child: const Text('Publish'),
          onPressed: () {},
        ),
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: IconButton(
            icon: const Icon(FluentIcons.back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: const Text('Add Campaign'),
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BaseBody(
              crossAxisAlignment: CrossAxisAlignment.start,
              widthFactor: 1.8,
              children: [],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: BaseBody(
                scrollController: ScrollController(),
                children: const [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
