import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:merchant_panel/app/products/product_tile.dart';

import '../../services/product/pagination_items.dart';
import '../../theme/layout_manager.dart';
import '../../widgets/body_base.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/header.dart';
import 'local/search.dart';

class AllProductsPage extends ConsumerWidget {
  const AllProductsPage({Key? key}) : super(key: key);
  static const routeName = '/products';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allProducts = ref.watch(itemsProviderNew);
    final productsFunc = ref.read(itemsProviderNew.notifier);
    final layout = ref.read(layoutProvider(context));

    final scCtrl = ScrollController();

    return ScaffoldPage(
      header: layout.isSmallScreen
          ? null
          : const Header(
              title: 'Products',
              showLeading: false,
            ),
      content: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: SearchAndCategory(),
          ),
          allProducts.when(
            data: (products) => Expanded(
              child: BaseBody(
                scrollController: scCtrl,
                widthFactor: layout.isSmallScreen ? 1 : 1.2,
                bottomPadding: 50,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 20),
                  MasonryGridView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: products.length,
                    gridDelegate:
                        SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: layout.isSmallScreen ? 2 : 5,
                    ),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    itemBuilder: (BuildContext context, int index) {
                      final product = products[index];
                      return ProductsTile(items: product);
                    },
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    child: const Text('load more'),
                    onPressed: () {
                      productsFunc.loadMore(products.last);
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            error: (error, st) => KErrorWidget(error: error, st: st),
            loading: () => const LoadingWidget(),
          ),
        ],
      ),
    );
  }
}
