import 'package:fluent_ui/fluent_ui.dart';
import 'package:merchant_panel/app/dash/dashboard.dart';
import 'package:merchant_panel/app/flash/flash_page.dart';
import 'package:merchant_panel/app/newsfeed/newsfeed.dart';
import 'package:merchant_panel/app/order/order_details.dart';
import 'package:merchant_panel/app/order/order_list.dart';
import 'package:merchant_panel/app/products/add/add_products.dart';
import 'package:merchant_panel/app/products/products_page.dart';
import 'package:merchant_panel/app/setting/app%20Settings/app_settings.dart';
import 'package:merchant_panel/app/setting/accounts/manage_account.dart';
import 'package:merchant_panel/app/setting/version_control/version_control.dart';
import 'package:merchant_panel/app/setting/settings_page.dart';
import 'package:merchant_panel/app/setting/users/users.dart';
import 'package:merchant_panel/app/slider/slider.dart';
import 'package:merchant_panel/auth/login.dart';
import 'package:merchant_panel/main.dart';

import '../app/campaign/add_campaign_page.dart';
import '../app/campaign/campaign_list.dart';
import '../app/nav_pane.dart';
import '../app/products/edit/edit_products.dart';
import '../app/products/product_model.dart';
import '../app/setting/live_stream/live_videos_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case NavigationPage.routeName:
        return FluentPageRoute(builder: (_) => const NavigationPage());

      case LoginPage.routeName:
        return FluentPageRoute(builder: (_) => const LoginPage());

      case AuthGate.routeName:
        return FluentPageRoute(builder: (_) => const AuthGate());

      case AccountManagementPage.routeName:
        return FluentPageRoute(builder: (_) => const AccountManagementPage());

      case AddCampaign.routeName:
        return FluentPageRoute(builder: (_) => const AddCampaign());

      case VersionControl.routeName:
        return FluentPageRoute(builder: (_) => const VersionControl());

      case AppSettings.routeName:
        return FluentPageRoute(builder: (_) => const AppSettings());

      case Campaign.routeName:
        return FluentPageRoute(builder: (_) => const Campaign());

      case FlashPage.routeName:
        return FluentPageRoute(builder: (_) => const FlashPage());

      case AddProducts.routeName:
        return FluentPageRoute(builder: (_) => const AddProducts());

      case News.routeName:
        return FluentPageRoute(builder: (_) => const News());

      case Settings.routeName:
        return FluentPageRoute(builder: (_) => const Settings());

      case Dash.routeName:
        return FluentPageRoute(builder: (_) => const Dash());

      case AllProductsPage.routeName:
        return FluentPageRoute(builder: (_) => const AllProductsPage());

      case OrderList.routeName:
        return FluentPageRoute(builder: (_) => const OrderList());

      case SliderPage.routeName:
        return FluentPageRoute(builder: (_) => const SliderPage());

      case UsersList.routeName:
        return FluentPageRoute(builder: (_) => const UsersList());

      case LiveVideosPage.routeName:
        return FluentPageRoute(builder: (_) => const LiveVideosPage());

      case EditProduct.routeName:
        if (args is ProductModel) {
          return FluentPageRoute(
            builder: (context) => EditProduct(args),
          );
        } else {
          return _errorRoute();
        }

      case OrderDetails.routeName:
        if (args is String) {
          return FluentPageRoute(
            builder: (context) => OrderDetails(orderId: args),
          );
        } else {
          return _errorRoute();
        }
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return FluentPageRoute(
      builder: (_) {
        return ScaffoldPage(
          content: Center(
            child: Text(
              'Error\n No route Found',
              style: FluentTheme.of(_)
                  .typography
                  .titleLarge!
                  .copyWith(color: Colors.warningPrimaryColor),
            ),
          ),
        );
      },
    );
  }
}
