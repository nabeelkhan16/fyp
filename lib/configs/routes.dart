import 'package:flutter/material.dart';
import 'package:trash_collector/screens/login_screen.dart';
import 'package:trash_collector/screens/profile/profile.dart';
import 'package:trash_collector/screens/sign_up.dart';

class Routes {
  Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/sign_up':
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case '/userInformationForm':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
