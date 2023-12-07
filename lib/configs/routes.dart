import 'package:flutter/material.dart';
import 'package:trash_collector/models/chat_model.dart';
import 'package:trash_collector/screens/login_screen.dart';
import 'package:trash_collector/screens/profile/profile.dart';
import 'package:trash_collector/screens/profile/settings.dart';
import 'package:trash_collector/screens/sign_up.dart';
import 'package:trash_collector/screens/home/chat_screen.dart';

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
      case '/chat':
        return MaterialPageRoute<ChatScreen>(
            builder: (_) => ChatScreen(
                  chat: routeSettings.arguments as ChatModel,
                ));
      case '/settings':
        return MaterialPageRoute(builder: (_) => const ProfileSettings());
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
