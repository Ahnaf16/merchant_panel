import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/extension/extensions.dart';
import 'package:merchant_panel/theme/theme.dart';

import '../../../widgets/cached_net_img.dart';
import '../campaign_provider.dart';

class SelectedCampaignItems extends ConsumerWidget {
  const SelectedCampaignItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItems = ref.watch(selectedProductsNotifierProvider);
    return ListView.builder(
      controller: ScrollController(),
      shrinkWrap: true,
      itemCount: selectedItems.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            trailing: IconButton(
              style: outlineButtonsStyle(radius: 5),
              icon: const Icon(FluentIcons.cancel),
              onPressed: () {
                ref
                    .read(selectedProductsNotifierProvider.notifier)
                    .remove(index);
              },
            ),
            leading: CachedNetImg(
              url: selectedItems[index].img,
              fit: BoxFit.contain,
              width: 60,
              height: 60,
            ),
            title: Text(selectedItems[index].name.showUntil(20)),
            // Text(selectedItems[index].name.length > 20
            //     ? '${selectedItems[index].name.substring(0, 20)}...'
            //     : selectedItems[index].name),
            subtitle: Row(
              children: [
                Text(
                  selectedItems[index].price.toCurrency(),
                  style: TextStyle(
                    decoration: selectedItems[index].haveDiscount
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                const SizedBox(width: 10),
                if (selectedItems[index].haveDiscount)
                  Text(
                    selectedItems[index].discount.toCurrency(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
