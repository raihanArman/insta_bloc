import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_bloc/blocs/auth/auth_bloc.dart';
import 'package:insta_bloc/config/custom_router.dart';
import 'package:insta_bloc/enums/enums.dart';
import 'package:insta_bloc/repositories/user/user_repository.dart';
import 'package:insta_bloc/screens/profile/bloc/profile_bloc.dart';
import 'package:insta_bloc/screens/screens.dart';

class TabNavigator extends StatelessWidget {
  static const String tabNavigatorRoot = '/';
  final GlobalKey<NavigatorState> navigatorKey;
  final BottomNavItem item;

  const TabNavigator({Key? key, required this.navigatorKey, required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders();
    return Navigator(
      key: navigatorKey,
      initialRoute: tabNavigatorRoot,
      onGenerateInitialRoutes: (_, initialRoute) {
        return [
          MaterialPageRoute(
              settings: RouteSettings(name: tabNavigatorRoot),
              builder: (context) => routeBuilders[initialRoute]!(context))
        ];
      },
      onGenerateRoute: CustomRouter.onGenerateNestedRoute,
    );
  }

  Map<String, WidgetBuilder> _routeBuilders() {
    return {tabNavigatorRoot: (context) => _getScreen(context, item)};
  }

  Widget _getScreen(BuildContext context, BottomNavItem item) {
    switch (item) {
      case BottomNavItem.feed:
        return FeedScreen();
      case BottomNavItem.search:
        return SearchScreen();
      case BottomNavItem.create:
        return CreatePostScreen();
      case BottomNavItem.notification:
        return NotificationScreen();
      case BottomNavItem.profile:
        return BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(
              userRepository: context.read<UserRepository>(),
              authBloc: context.read<AuthBloc>())
            ..add(ProfileLoadUser(
                userId: context.read<AuthBloc>().state.user!.uid)),
          child: ProfileScreen(),
        );
      default:
        return Scaffold();
    }
  }
}
