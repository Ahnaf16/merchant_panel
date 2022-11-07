// ignore_for_file: use_build_context_synchronously

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:merchant_panel/app/campaign/add_campaign_page.dart';
import 'package:merchant_panel/app/campaign/campaign_model.dart';
import 'package:merchant_panel/services/offers/campaign_services.dart';
import 'package:merchant_panel/theme/theme.dart';
import 'package:merchant_panel/theme/theme_manager.dart';
import 'package:merchant_panel/widgets/delete_button.dart';
import 'package:merchant_panel/widgets/error_widget.dart';
import 'package:merchant_panel/widgets/text_icon.dart';
import '../../services/image_services.dart';
import '../../theme/layout_manager.dart';
import '../../widgets/header.dart';
import '../../widgets/widget_export.dart';
import 'local/campaign_preview.dart';

class Campaign extends ConsumerWidget {
  const Campaign({Key? key}) : super(key: key);
  static const routeName = '/campaign';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campaignList = ref.watch(campaignListProvider);
    final layout = ref.read(layoutProvider(context));
    var isSmall = layout.isSmallScreen;

    return ScaffoldPage(
      header: isSmall
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextIcon(
                text: 'Add Campaign',
                icon: FluentIcons.add,
                showBorder: true,
                onPressed: () {
                  Navigator.pushNamed(context, AddCampaign.routeName);
                },
              ),
            )
          : Header(
              showLeading: false,
              title: 'Campaign',
              commandBar: FilledButton(
                child: const Text('Add Campaign'),
                onPressed: () {
                  Navigator.pushNamed(context, AddCampaign.routeName);
                },
              ),
            ),
      padding: isSmall ? const EdgeInsets.all(0) : null,
      content: BaseBody(
        widthFactor: isSmall ? 1 : 1.3,
        children: [
          campaignList.when(
              data: (campaigns) => campaigns.isEmpty
                  ? Container(
                      height: 80,
                      decoration:
                          boxDecoration.copyWith(color: Colors.grey[30]),
                      child: const Center(
                        child: Text('E M P T Y'),
                      ),
                    )
                  : StaggeredGrid.count(
                      crossAxisCount: isSmall ? 1 : 4,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children: List.generate(
                        campaigns.length,
                        (index) => Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Stack(
                              children: [
                                if (isSmall)
                                  CampaignFlyout(
                                    campaign: campaigns[index],
                                    isPhone: isSmall,
                                    child: Card(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(8),
                                      ),
                                      child: CachedNetImg(
                                        url: campaigns[index].image,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                if (!isSmall)
                                  Card(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(8),
                                    ),
                                    child: CachedNetImg(
                                      url: campaigns[index].image,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                if (!isSmall)
                                  Positioned(
                                    right: 0,
                                    child: CampaignFlyout(
                                      campaign: campaigns[index],
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                        decoration: boxDecoration,
                                        child: const Icon(FluentIcons.more),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.5),
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(8),
                                ),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    campaigns[index].title,
                                    style: textTheme(context).body!.copyWith(
                                          color: Colors.white,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              error: (error, st) => KErrorWidget(error: error, st: st),
              loading: () => const LoadingWidget()),
        ],
      ),
    );
  }
}

class CampaignFlyout extends StatelessWidget {
  const CampaignFlyout({
    Key? key,
    required this.campaign,
    required this.child,
    this.isPhone = false,
  }) : super(key: key);

  final CampaignModel campaign;
  final Widget child;
  final bool isPhone;
  @override
  Widget build(BuildContext context) {
    return Flyout(
      openMode: isPhone ? FlyoutOpenMode.longPress : FlyoutOpenMode.press,
      content: (context) => MenuFlyout(
        items: [
          if (!isPhone)
            MenuFlyoutItem(
              text: const Text('View'),
              leading: const Icon(FluentIcons.view),
              onPressed: () async {
                await showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) =>
                      CampaignView(campaign: campaign, isPhone: isPhone),
                );
              },
            ),
          MenuFlyoutItem(
            text: const Text('Edit'),
            leading: const Icon(FluentIcons.edit),
            onPressed: () {},
          ),
          MenuFlyoutItem(
            text: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.warningPrimaryColor,
              ),
            ),
            leading: const Icon(
              FluentIcons.delete,
              color: Colors.warningPrimaryColor,
            ),
            onPressed: () async {
              await deleteButtonDialog(
                context: context,
                onDelete: () async {
                  await CampaignServices.deleteCampaign(campaign: campaign);

                  UploadImage.deleteImage(
                      fileName: campaign.title, path: 'campaign_imgs');
                },
              );
            },
          ),
        ],
      ),
      child: isPhone
          ? GestureDetector(
              onTap: () {
                if (isPhone) {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) =>
                        CampaignView(campaign: campaign, isPhone: isPhone),
                  );
                }
              },
              child: child,
            )
          : child,
    );
  }
}
