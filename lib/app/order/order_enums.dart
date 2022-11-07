import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

enum OrderStatus {
  pending(Icons.pending_outlined),
  processing(Icons.autorenew),
  picked(MdiIcons.packageVariantClosedCheck),
  shipped(MdiIcons.truckDeliveryOutline),
  delivered(Icons.markunread_mailbox_outlined),
  cancelled(Icons.cancel_outlined),
  duplicate(MdiIcons.contentDuplicate);

  const OrderStatus(this.icon);
  final IconData icon;

  @override
  String toString() {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.picked:
        return 'Picked';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.duplicate:
        return 'Duplicate';
      default:
        return 'Pending';
    }
  }
}

extension Enums on String {
  OrderStatus toStatus() {
    switch (this) {
      case 'Pending':
        return OrderStatus.pending;
      case 'Processing':
        return OrderStatus.processing;
      case 'Picked':
        return OrderStatus.picked;
      case 'Shipped':
        return OrderStatus.shipped;
      case 'Delivered':
        return OrderStatus.delivered;
      case 'Cancelled':
        return OrderStatus.cancelled;
      case 'Duplicate':
        return OrderStatus.duplicate;
      default:
        return OrderStatus.pending;
    }
  }
}
