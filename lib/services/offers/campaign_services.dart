import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/app/campaign/campaign_model.dart';

class CampaignServices {
  static addCampaign({
    required CampaignModel campaign,
    required List<CampaignItemModel> campaignItem,
  }) async {
    EasyLoading.show(status: 'Adding Campaign');
    final firestore = FirebaseFirestore.instance;

    final campaignRef = firestore.collection('campaign').doc(campaign.title);
    final campaignItemsRef = firestore
        .collection('campaign')
        .doc(campaign.title)
        .collection(campaign.title);

    await campaignRef.set(campaign.toJson());

    for (final item in campaignItem) {
      await campaignItemsRef.add(item.toJson());
    }

    EasyLoading.showSuccess('Campaign Added');
  }

  static deleteCampaign({
    required CampaignModel campaign,
  }) async {
    EasyLoading.show(status: 'Deleting Campaign');
    final firestore = FirebaseFirestore.instance;

    final campaignRef = firestore.collection('campaign').doc(campaign.title);
    final campaignItemsRef = firestore
        .collection('campaign')
        .doc(campaign.title)
        .collection(campaign.title);

    await campaignRef.delete();

    await campaignItemsRef.get().then((snapshot) {
      for (final doc in snapshot.docs) {
        doc.reference.delete();
      }
    });

    EasyLoading.showSuccess('Campaign Deleted');
  }
}

final campaignListProvider =
    StreamProvider.autoDispose<List<CampaignModel>>((ref) {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final snap = firestore.collection("campaign").snapshots();
  return snap.map(
    (snapshot) {
      return snapshot.docs.map((doc) {
        return CampaignModel.fromDocument(doc);
      }).toList();
    },
  );
});

final campaignItemProvider = StreamProvider.autoDispose
    .family<List<CampaignItemModel>, String>((ref, title) {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final snap =
      firestore.collection("campaign").doc(title).collection(title).snapshots();
  return snap.map(
    (snapshot) {
      return snapshot.docs.map((doc) {
        return CampaignItemModel.fromDocument(doc);
      }).toList();
    },
  );
});
