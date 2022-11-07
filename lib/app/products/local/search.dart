import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/services/global_provider.dart';

import '../../../services/product/pagination_items.dart';
import '../../../theme/theme.dart';

class SearchAndCategory extends ConsumerWidget {
  const SearchAndCategory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryList = ref.watch(categoryListProvider);
    final category = ref.watch(selectedCategory);
    final productsFunc = ref.read(itemsProviderNew.notifier);
    return Row(
      children: [
        Expanded(
          flex: 2,
          //---------------------search box
          child: TextBox(
            controller: productsFunc.searchCtrl,
            padding: const EdgeInsets.all(8),
            decoration: boxDecoration,
            prefix: const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Icon(FluentIcons.search),
            ),
            suffix: IconButton(
              icon: const Icon(FluentIcons.clear),
              onPressed: () {
                productsFunc.firstFetch();
                productsFunc.searchCtrl.clear();
              },
            ),
            suffixMode: OverlayVisibilityMode.editing,
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                productsFunc.search();
              } else {
                productsFunc.firstFetch();
              }
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            decoration: boxDecoration,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: ComboBox<String>(
                placeholder: const Text('Category'),
                isExpanded: true,
                items: categoryList
                    .map((e) => ComboBoxItem<String>(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                value: category,
                onChanged: (value) {
                  productsFunc.filter(value);
                  ref.read(selectedCategory.notifier).state = value;
                },
              ),
            ),
          ),
        ),
        if (category != null)
          IconButton(
            icon: const Icon(FluentIcons.reset),
            onPressed: () {
              productsFunc.firstFetch();
              ref.read(selectedCategory.notifier).state = null;
            },
          ),
        // if (category != null) const SizedBox(width: 20),
      ],
    );
  }
}
