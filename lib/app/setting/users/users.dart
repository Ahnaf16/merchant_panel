import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:merchant_panel/app/setting/users/search.dart';

import 'package:merchant_panel/app/setting/users/user_provider.dart';
import 'package:merchant_panel/app/setting/users/users_orders.dart';
import 'package:merchant_panel/app/setting/users/user_model.dart';
import 'package:merchant_panel/theme/layout_manager.dart';
import 'package:merchant_panel/theme/theme.dart';
import 'package:merchant_panel/widgets/body_base.dart';
import 'package:merchant_panel/widgets/error_widget.dart';
import 'package:merchant_panel/widgets/header.dart';
import 'package:merchant_panel/widgets/img_view.dart';
import 'package:merchant_panel/widgets/text_icon.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../voucher/voucher_dialog.dart';

class UsersList extends ConsumerWidget {
  const UsersList({Key? key}) : super(key: key);
  static const String routeName = '/users';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userList = ref.watch(userListProvider);
    final userListFunc = ref.read(userListProvider.notifier);
    final usersCount = ref.watch(totalUserProvider);
    final layout = ref.watch(layoutProvider(context));
    final search = ref.watch(searchBy);
    final isSmall = layout.isSmallScreen;
    final total =
        usersCount.asData == null ? 'loading...' : usersCount.asData!.value;
    return SafeArea(
      child: ScaffoldPage(
        header: const Header(title: 'All Users'),
        content: BaseBody(
          widthFactor: isSmall ? 1 : 1.1,
          children: [
            SearchUsers(
              userListFunc: userListFunc,
              search: search,
            ),
            const SizedBox(height: 10),
            TextIcon(
              text: 'Total : $total',
              icon: FluentIcons.user_gauge,
            ),
            const SizedBox(height: 10),
            userList.when(
              data: (users) {
                if (users.isEmpty) {
                  return Container(
                    decoration: boxDecoration,
                    height: isSmall ? 60 : 150,
                    width: double.infinity,
                    child: const Center(
                      child: Text('E M P T Y'),
                    ),
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MasonryGridView.builder(
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: users.length,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                        gridDelegate:
                            SliverSimpleGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isSmall ? 2 : 5,
                        ),
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return UserCard(user: user);
                        },
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton(
                          onPressed: () {
                            userListFunc.loadMore(
                              users.last,
                            );
                          },
                          child: const Text('Load More'),
                        ),
                      ),
                    ],
                  );
                }
              },
              error: (error, st) => KErrorWidget(error: error, st: st),
              loading: () => const LoadingWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

class UserCard extends ConsumerWidget {
  const UserCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = ref.watch(layoutProvider(context));
    final isSmall = layout.isSmallScreen;
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => showDialog(
              barrierDismissible: true,
              context: context,
              builder: (context) => ImgView(
                tag: user.photoUrl,
                url: user.photoUrl,
                isSmall: isSmall,
              ),
            ),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.transparent,
              backgroundImage: CachedNetworkImageProvider(
                user.photoUrl,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(user.displayName),
          const SizedBox(height: 5),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (user.phone != 'Phone')
                TextIcon(
                  text: user.phone,
                  icon: FluentIcons.phone,
                ),
              if (user.email != 'Email')
                TextIcon(
                  text: user.email,
                  icon: FluentIcons.mail,
                ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            runAlignment: WrapAlignment.start,
            children: [
              if (user.loginMethod == 'phone')
                const Chip(
                  image: Icon(MdiIcons.phone),
                ),
              if (user.loginMethod == 'google.com')
                const Chip(
                  image: Icon(MdiIcons.google),
                ),
              if (user.loginMethod == 'facebook.com')
                const Chip(
                  image: Icon(MdiIcons.facebook),
                ),
              Chip(
                text: const Text('Gift Voucher'),
                onPressed: () {
                  showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (context) => VoucherDialog(user: user),
                  );
                },
              ),
              Chip(
                text: Text('View orders (${user.totalOrders})'),
                onPressed: () {
                  showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (context) {
                      return UserSpecificOrderList(
                        user: user,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
