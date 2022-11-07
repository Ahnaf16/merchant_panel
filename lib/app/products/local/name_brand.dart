import 'package:fluent_ui/fluent_ui.dart';

import '../add/add_products.dart';
import '../add/adding_provider.dart';

class NameAndBrand extends StatelessWidget {
  const NameAndBrand({
    Key? key,
    required this.ctrls,
    required this.brandList,
  }) : super(key: key);

  final List brandList;
  final AddProductsNotifier ctrls;

  @override
  Widget build(BuildContext context) {
    return Card(
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        //------------- name and brand
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            kTextBox(
              header: 'Name',
              controller: ctrls.nameC,
            ),
            const SizedBox(height: 20),
            kTextBox(
              header: 'Brand',
              controller: ctrls.brandC,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: brandList
                  .map(
                    (text) => Chip(
                      text: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(text),
                      ),
                      onPressed: () => ctrls.brandC.text = text,
                    ),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
