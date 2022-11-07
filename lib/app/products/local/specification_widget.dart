import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../theme/theme.dart';
import '../add/adding_provider.dart';

class Axa extends ConsumerStatefulWidget {
  const Axa({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AxaState();
}

class AxaState extends ConsumerState<Axa> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SpecificationWidget extends ConsumerStatefulWidget {
  const SpecificationWidget({
    Key? key,
    required this.ctrls,
    required this.specificationList,
  }) : super(key: key);

  final AddProductsNotifier ctrls;
  final Map<String, String> specificationList;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      SpecificationWidgetState();
}

class SpecificationWidgetState extends ConsumerState<SpecificationWidget> {
  final specFocus = FocusNode();
  final FlyoutController fluCtrlRam = FlyoutController();
  final FlyoutController flyCtrlStorage = FlyoutController();
  final List ramVariants = [
    '4GB',
    '6GB',
    '8GB',
    '12GB',
  ];
  final List storageVariants = [
    '64GB',
    '128GB',
    '256GB',
    '512GB',
  ];
  @override
  void dispose() {
    fluCtrlRam.dispose();
    flyCtrlStorage.dispose();
    specFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      borderRadius: BorderRadius.circular(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Add Specification'),
              const SizedBox(width: 10),
              Flyout(
                openMode: FlyoutOpenMode.press,
                content: (context) => Card(
                  child: Text(
                    'Separate each specification type and value with a "~",\n'
                    'For example: Color~Black, Ram~4GB',
                    style: FluentTheme.of(context).typography.body,
                  ),
                ),
                child: const Icon(MdiIcons.helpCircleOutline),
              ),
            ],
          ),
          const SizedBox(height: 5),
          TextBox(
            focusNode: specFocus,
            controller: widget.ctrls.specificationC,
            suffixMode: OverlayVisibilityMode.editing,
            outsidePrefix: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Container(
                decoration: boxDecoration,
                child: IconButton(
                  style: ButtonStyle(
                    padding: ButtonState.all(
                      const EdgeInsets.all(8.0),
                    ),
                  ),
                  icon: const Icon(FluentIcons.down),
                  onPressed: () {
                    ref.read(specificationProvider.notifier).addSpecification(
                          widget.ctrls.specificationC.text,
                        );
                  },
                ),
              ),
            ),
            suffix: IconButton(
              icon: const Icon(FluentIcons.clear),
              onPressed: () {
                widget.ctrls.specificationC.clear();
              },
            ),
            decoration: BoxDecoration(
              color: Colors.grey[10],
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Colors.grey[100],
                width: 1,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            children: [
              Text(
                'Specifications: ',
                style: FluentTheme.of(context).typography.bodyLarge,
              ),
              const SizedBox(width: 10),
              Flyout(
                controller: fluCtrlRam,
                openMode: FlyoutOpenMode.press,
                child: Chip(
                  text: const Text('RAM'),
                  onPressed: () {
                    fluCtrlRam.open();
                  },
                ),
                content: (context) => MenuFlyout(
                  items: ramVariants
                      .map(
                        (variant) => MenuFlyoutItem(
                          text: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text('$variant'),
                          ),
                          leading: const Icon(FluentIcons.file_system),
                          onPressed: () {
                            widget.ctrls.specificationC.text = 'RAM~$variant';
                            fluCtrlRam.close();
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(width: 10),
              Flyout(
                controller: flyCtrlStorage,
                openMode: FlyoutOpenMode.press,
                child: Chip(
                  text: const Text('Storage'),
                  onPressed: () {
                    flyCtrlStorage.open();
                  },
                ),
                content: (context) => MenuFlyout(
                  items: storageVariants
                      .map(
                        (variant) => MenuFlyoutItem(
                          text: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text('$variant'),
                          ),
                          leading: const Icon(FluentIcons.file_system),
                          onPressed: () {
                            widget.ctrls.specificationC.text =
                                'Storage~$variant';
                            flyCtrlStorage.close();
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(width: 10),
              Chip(
                text: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3),
                  child: Text('Display'),
                ),
                onPressed: () {
                  widget.ctrls.specificationC.text = 'Display~';
                  specFocus.requestFocus();
                },
              ),
              const SizedBox(width: 10),
              Chip(
                text: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3),
                  child: Text('Chipset'),
                ),
                onPressed: () {
                  widget.ctrls.specificationC.text = 'Chipset~';
                  specFocus.requestFocus();
                },
              ),
              const SizedBox(width: 10),
              Chip(
                text: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3),
                  child: Text('Charging'),
                ),
                onPressed: () {
                  widget.ctrls.specificationC.text = 'Charging~';
                  specFocus.requestFocus();
                },
              ),
              const SizedBox(width: 10),
              Chip(
                text: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3),
                  child: Text('Battery'),
                ),
                onPressed: () {
                  widget.ctrls.specificationC.text = 'Battery~';
                  specFocus.requestFocus();
                },
              ),
              const SizedBox(width: 10),
              if (widget.specificationList.isNotEmpty)
                TextButton(
                  child: const Text('Clear'),
                  onPressed: () {
                    ref.read(specificationProvider.notifier).clear();
                  },
                ),
            ],
          ),
          if (widget.specificationList.isNotEmpty) const SizedBox(height: 10),
          if (widget.specificationList.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.specificationList.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    IconButton(
                      icon: const Icon(FluentIcons.cancel),
                      onPressed: () {
                        ref
                            .read(specificationProvider.notifier)
                            .removeSpecification(
                              widget.specificationList.keys.elementAt(index),
                            );
                      },
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${widget.specificationList.keys.elementAt(index)}:',
                      style: FluentTheme.of(context).typography.body,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      widget.specificationList.values.elementAt(index),
                      style: FluentTheme.of(context).typography.body,
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}
