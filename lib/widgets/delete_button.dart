import 'package:fluent_ui/fluent_ui.dart';

import '../theme/theme.dart';

Future<Object?> deleteButtonDialog({
  required BuildContext context,
  required Function()? onDelete,
  Function()? onCancel,
  String? object,
}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => DeleteDialog(
      onCancel: onCancel,
      onDelete: onDelete,
      object: object,
    ),
  );
}

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({
    Key? key,
    this.onDelete,
    this.onCancel,
    this.object,
  }) : super(key: key);

  final Function()? onDelete;
  final Function()? onCancel;
  final String? object;

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text('Delete ${object ?? 'Product'}'),
      content: Text('Are you sure you want to delete this $object?'),
      actions: [
        TextButton(
          style: hoveringButtonsStyle(Colors.warningPrimaryColor),
          onPressed: onDelete!,
          child: const Text('Delete'),
        ),
        TextButton(
          onPressed: onCancel ??
              () {
                Navigator.pop(context);
              },
          style: hoveringButtonsStyle(Colors.blue),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
