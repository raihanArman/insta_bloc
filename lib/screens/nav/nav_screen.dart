import 'package:flutter/material.dart';

class NavScreen extends StatelessWidget {
  static const String routeName = '/nav';
  static Route route() {
    return PageRouteBuilder(
        settings: const RouteSettings(name: routeName),
        transitionDuration: Duration(seconds: 0),
        pageBuilder: (_, __, ___) => NavScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Nav Screen'),
      ),
    );
  }
}
