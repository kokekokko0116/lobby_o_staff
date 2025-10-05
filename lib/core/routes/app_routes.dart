import 'package:flutter/material.dart';
import 'route_names.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/test/theme_showcase_screen.dart';
import '../../presentation/screens/app/call_screen.dart';
import '../../presentation/screens/app/home_screen.dart';
// import '../../presentation/screens/service/service_application_screen.dart';

/// アプリのルート設定
class AppRoutes {
  AppRoutes._();

  /// 初期ルート
  static const String initialRoute = RouteNames.login;
  // static const String initialRoute = RouteNames.themeShowcase;

  /// ルート定義マップ
  static Map<String, WidgetBuilder> get routes => {
    RouteNames.login: (context) => const LoginScreen(),
    RouteNames.register: (context) => const RegisterScreen(),
    RouteNames.themeShowcase: (context) => const ThemeShowcaseScreen(),
    RouteNames.home: (context) => const HomeScreen(),
    RouteNames.call: (context) => const CallScreen(),
    // RouteNames.serviceApplication: (context) => const ServiceApplicationScreen(),
  };

  /// 名前付きルートのハンドリング（動的ルート用）
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.login:
        return _createRoute(const LoginScreen());
      case RouteNames.register:
        return _createRoute(const RegisterScreen());
      case RouteNames.home:
        return _createRoute(const HomeScreen());
      case RouteNames.call:
        return _createRoute(const CallScreen());
      case RouteNames.themeShowcase:
        return _createRoute(const ThemeShowcaseScreen());
      default:
        return _createRoute(
          Scaffold(body: Center(child: Text('ページが見つかりません: ${settings.name}'))),
        );
    }
  }

  /// カスタムトランジション付きルート作成
  static PageRouteBuilder _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// 簡単なページ遷移メソッド
  static Future<void> pushNamed(BuildContext context, String routeName) {
    return Navigator.pushNamed(context, routeName);
  }

  /// 置き換え遷移
  static Future<void> pushReplacementNamed(
    BuildContext context,
    String routeName,
  ) {
    return Navigator.pushReplacementNamed(context, routeName);
  }

  /// 全てクリアして遷移
  static Future<void> pushNamedAndRemoveUntil(
    BuildContext context,
    String routeName,
  ) {
    return Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
    );
  }
}
