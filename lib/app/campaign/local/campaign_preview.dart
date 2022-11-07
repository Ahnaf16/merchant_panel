import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/extension/extensions.dart';

import '../../../services/offers/campaign_services.dart';
import '../../../widgets/cached_net_img.dart';
import '../../../widgets/error_widget.dart';
import '../../../widgets/header.dart';
import '../campaign_model.dart';

class CampaignView extends ConsumerWidget {
  const CampaignView({
    super.key,
    required this.campaign,
    this.isPhone = false,
  });
  final CampaignModel campaign;
  final bool isPhone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campaignItemsList = ref.watch(campaignItemProvider(campaign.title));

    return ContentDialog(
      constraints: BoxConstraints(
        maxWidth:
            isPhone ? double.infinity : MediaQuery.of(context).size.width / 1.5,
      ),
      title: Header(
        title: campaign.title,
        showLeading: isPhone,
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetImg(
                url: campaign.image,
                fit: BoxFit.cover,
                height: 100,
                width: 300,
              ),
            ),
            const SizedBox(height: 10),
            campaignItemsList.when(
                data: (campaigns) => ListView.builder(
                      itemCount: campaigns.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: CachedNetImg(
                              url: campaigns[index].img,
                              height: 60,
                              width: 60,
                            ),
                            title: Text(campaigns[index].name.showUntil(20)),
                            subtitle: Row(
                              children: [
                                Text(
                                  campaigns[index].price.toCurrency(),
                                  style: TextStyle(
                                    decoration: campaigns[index].haveDiscount
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                if (campaigns[index].haveDiscount)
                                  Text(
                                    campaigns[index].discount.toCurrency(),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                error: (error, st) => KErrorWidget(error: error, st: st),
                loading: () => const LoadingWidget()),
          ],
        ),
      ),
    );
  }
}
