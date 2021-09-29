import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_bloc/enums/enums.dart';
import 'package:insta_bloc/screens/nav/cubit/bottom_nav_bar_cubit.dart';
import 'package:insta_bloc/screens/nav/widgets/widgets.dart';

class NavScreen extends StatelessWidget {
  static const String routeName = '/nav';
  static Route route() {
    return PageRouteBuilder(
        settings: const RouteSettings(name: routeName),
        transitionDuration: Duration(seconds: 0),
        pageBuilder: (_, __, ___) => BlocProvider<BottomNavBarCubit>(
            create: (_) => BottomNavBarCubit(), child: NavScreen()));
  }

  final Map<BottomNavItem, GlobalKey<NavigatorState>> navigatorKeys = {
    BottomNavItem.feed: GlobalKey<NavigatorState>(),
    BottomNavItem.search: GlobalKey<NavigatorState>(),
    BottomNavItem.create: GlobalKey<NavigatorState>(),
    BottomNavItem.notification: GlobalKey<NavigatorState>(),
    BottomNavItem.profile: GlobalKey<NavigatorState>(),
  };

  final Map<BottomNavItem, IconData> items = const {
    BottomNavItem.feed: Icons.home,
    BottomNavItem.search: Icons.search,
    BottomNavItem.create: Icons.add,
    BottomNavItem.notification: Icons.favorite_border,
    BottomNavItem.profile: Icons.account_circle,
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
          builder: (context, state) {
            return Scaffold(
              body: Stack(
                  children: items
                      .map((item, _) => MapEntry(
                          item,
                          _buildOffStateNavigatorItem(
                              item, item == state.selectedItem)))
                      .values
                      .toList()),
              bottomNavigationBar: BottomNavBar(
                onTap: (index) {
                  final selectedItem = BottomNavItem.values[index];
                  context
                      .read<BottomNavBarCubit>()
                      .updateSelectedItem(selectedItem);
                  _selectedBottomNavItem(context, selectedItem,
                      selectedItem == state.selectedItem);
                },
                items: items,
                selectedItem: state.selectedItem,
              ),
            );
          },
        ));
  }

  void _selectedBottomNavItem(
      BuildContext context, BottomNavItem selectedItem, bool isSameItem) {
    if (isSameItem) {
      navigatorKeys[selectedItem]!
          .currentState!
          .popUntil((route) => route.isFirst);
    }
    context.read<BottomNavBarCubit>().updateSelectedItem(selectedItem);
  }

  Widget _buildOffStateNavigatorItem(
      BottomNavItem currentItem, bool isSelected) {
    return Offstage(
      offstage: !isSelected,
      child: TabNavigator(
          navigatorKey: navigatorKeys[currentItem]!, item: currentItem),
    );
  }
}
