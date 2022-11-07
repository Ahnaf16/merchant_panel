import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merchant_panel/app/order/order_model.dart';
import 'package:merchant_panel/auth/auth_provider.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';

class SheetsCredModel {
  final String id;
  final String key;
  final String backupId;

  SheetsCredModel({
    required this.id,
    required this.key,
    required this.backupId,
  });

  factory SheetsCredModel.fromDoc(DocumentSnapshot doc) {
    return SheetsCredModel(
      id: doc['id'],
      key: doc['key'],
      backupId: doc['backupId'],
    );
  }
}

final sheetCredProvider = StreamProvider<SheetsCredModel>((ref) async* {
  final fire = FirebaseFirestore.instance;

  final snap = fire.collection('inApp').doc('gsheets').snapshots();

  yield* snap.map((doc) => SheetsCredModel.fromDoc(doc));
});

final sheetNProvider =
    StateNotifierProvider<SheetNotifier, SheetsCredModel?>((ref) {
  return SheetNotifier();
});

class SheetNotifier extends StateNotifier<SheetsCredModel?> {
  SheetNotifier() : super(null);

  final fire = FirebaseFirestore.instance;

  Future<SheetsCredModel> getSheetCred() async {
    final snap = fire.collection('inApp').doc('gsheets').get();

    return SheetsCredModel.fromDoc(await snap);
  }

  uploadToSheet(SheetsCredModel sheetCred, OrderModel order) async {
    try {
      EasyLoading.show(status: 'Uploading to sheet...');

      final sheet = GSheets(sheetCred.key);

      final gsheet = await sheet.spreadsheet(sheetCred.id);
      final gsheetBackUp = await sheet.spreadsheet(sheetCred.backupId);

      final wsheet = gsheet.worksheetByTitle('Sheet1');
      final wsheetBackUp = gsheetBackUp.worksheetByTitle('Sheet1');

      EasyLoading.showInfo('Adding to sheet...');

      await wsheet!.values.appendRow([
        order.invoice,
        order.address.name,
        '${order.address.division},${order.address.district},${order.address.address}',
        order.address.billingNumber,
        order.items.map((item) => item.name).join(','),
        order.items.map((item) => item.quantity).join(','),
        order.total,
        order.total == order.paidAmount
            ? 'Full Paid'
            : (order.paidAmount == 0
                ? 'Full Condition'
                : '${order.total - order.paidAmount} Condition'),
        order.paidAmount == 0 ? 'Home Delivery' : '',
        '',
        DateFormat('dd/MM/yyy hh:mm:ss').format(DateTime.now()),
        getUser!.displayName,
      ]);

      EasyLoading.showInfo('Adding to backup sheet...');

      await wsheetBackUp!.values.appendRow([
        order.invoice,
        order.address.name,
        '${order.address.division},${order.address.district},${order.address.address}',
        order.address.billingNumber,
        order.items.map((item) => item.name).join(','),
        order.items.map((item) => item.quantity).join(','),
        order.total,
        order.total == order.paidAmount
            ? 'Full Paid'
            : (order.paidAmount == 0
                ? 'Full Condition'
                : '${order.total - order.paidAmount} Condition'),
        order.paidAmount == 0 ? 'Home Delivery' : '',
        '',
        DateFormat('dd/MM/yyy hh:mm:ss').format(DateTime.now()),
        getUser!.displayName,
      ]);
      EasyLoading.showSuccess('Uploaded to sheet');
    } catch (err, st) {
      EasyLoading.showError(err.toString());
      log(err.toString());
      log(st.toString());
    }
  }
}
