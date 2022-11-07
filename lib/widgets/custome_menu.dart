// import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
// import 'package:fluent_ui/fluent_ui.dart';

// class KMenuFlyOut extends StatelessWidget {
//   const KMenuFlyOut({
//     Key? key,
//     required this.child,
//     this.menuLength,
//     this.pressType = PressType.singleClick,
//     this.items,
//     this.showArrow = true,
//     this.position,
//     this.controller,
//   }) : super(key: key);

//   final Widget child;
//   final List<Widget>? items;
//   final int? menuLength;
//   final PressType pressType;
//   final bool showArrow;
//   final PreferredPosition? position;
//   final CustomPopupMenuController? controller;

//   @override
//   Widget build(BuildContext context) {
//     return CustomPopupMenu(
//       controller: controller,
//       pressType: pressType,
//       showArrow: showArrow,
//       position: position,
//       menuBuilder: () {
//         return Card(
//           padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ...items!,
//               ],
//             ),
//           ),
//         );
//       },
//       child: child,
//     );
//   }
// }

// class KMenuFlyOutItem extends StatelessWidget {
//   const KMenuFlyOutItem({
//     Key? key,
//     this.leading,
//     this.title,
//     this.trailing,
//     this.onTap,
//   }) : super(key: key);

//   final Widget? leading;
//   final Widget? title;
//   final Widget? trailing;
//   final Function()? onTap;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
//       child: SizedBox(
//         width: 200,
//         child: Button(
//           style: ButtonStyle(
//             elevation: ButtonState.all(0),
//             shadowColor: ButtonState.all(Colors.transparent),
//             border: ButtonState.all(BorderSide.none),
//             backgroundColor: ButtonState.resolveWith(
//               (states) {
//                 if (states.isPressing) {
//                   return Colors.grey.withOpacity(.3);
//                 } else if (states.isHovering) {
//                   return Colors.grey.withOpacity(.1);
//                 }
//                 return Colors.transparent;
//               },
//             ),
//             foregroundColor: ButtonState.all(Colors.black),
//           ),
//           onPressed: onTap,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               leading ?? const SizedBox.shrink(),
//               const SizedBox(width: 8),
//               title ?? const SizedBox.shrink(),
//               const SizedBox(width: 8),
//               const Spacer(),
//               trailing ?? const SizedBox.shrink(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class IncrementButton extends KMenuFlyOutItem {
//   const IncrementButton({
//     Key? key,
//     required this.count,
//     this.increment,
//     this.decrement,
//   }) : super(key: key);
//   final int count;
//   final Function()? increment;
//   final Function()? decrement;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         IconButton(
//           icon: const Icon(
//             FluentIcons.chevron_left_med,
//           ),
//           onPressed: decrement,
//         ),
//         const SizedBox(width: 5),
//         Text(
//           '$count',
//         ),
//         const SizedBox(width: 5),
//         IconButton(
//           icon: const Icon(
//             FluentIcons.chevron_right_med,
//           ),
//           onPressed: increment,
//         ),
//       ],
//     );
//   }
// }
