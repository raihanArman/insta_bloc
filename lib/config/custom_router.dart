import 'package:flutter/material.dart';
import 'package:insta_bloc/screens/login/login_screen.dart';
import 'package:insta_bloc/screens/screens.dart';
import 'package:insta_bloc/screens/splash/splash_screen.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => Scaffold(), settings: RouteSettings(name: '/'));
      case SplashScreen.routeName:
        return SplashScreen.route();
      case LoginScreen.routeName:
        return LoginScreen.route();
      case NavScreen.routeName:
        return NavScreen.route();
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
        settings: RouteSettings(name: '/error'),
        builder: (_) => Scaffold(
              appBar: AppBar(title: Text('Error')),
              body: Center(
                child: Text('Somthing went error'),
              ),
            ));
  }
}
