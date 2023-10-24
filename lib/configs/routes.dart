import 'package:flutter/material.dart';
import 'package:trash_collector/login_screen.dart';
import 'package:trash_collector/sign_up.dart';

class Routes {
  Route<dynamic> generateRoute(RouteSettings routeSettings) {

    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/sign_up':
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
