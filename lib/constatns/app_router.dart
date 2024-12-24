import 'package:flutter/material.dart';
import 'package:tiki/pages/onboarding/onboardinng.dart';
import 'package:tiki/pages/tabs/mainpage.dart';

import '../pages/tabs/userscreen.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print('The Route is: ${settings.name}');

    switch (settings.name) {
      case '/':
      //   return HomeScreen.route();
      // case MainPage.routeName:
      //   return MainPage.route();
      // case UsersScreen.routeName:
      //   return UsersScreen.route(user: settings.arguments as User);
      case OnboardingScreen.routeName:
        return OnboardingScreen.route();
      // case AuthenticationWrapper.routeName:
      //   return AuthenticationWrapper.route();
      // case ProfileScreen.routeName:
      //   return ProfileScreen.route();
      // case ChatScreen.routeName:
      //   return ChatScreen.route(userMatch: settings.arguments as UserMatch);
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(appBar: AppBar(title: const Text('error'))),
      settings: const RouteSettings(name: '/error'),
    );
  }
}
