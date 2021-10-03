import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_bloc/repositories/repositories.dart';
import 'package:insta_bloc/screens/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:insta_bloc/screens/profile/bloc/profile_bloc.dart';

class EditProfileScreenArgs {
  final BuildContext context;
  const EditProfileScreenArgs({required this.context});
}

class EditProfileScreen extends StatelessWidget {
  static const String routeName = '/editProfile';

  static Route route({required EditProfileScreenArgs args}) {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (context) => BlocProvider<EditProfileCubit>(
              create: (context) => EditProfileCubit(
                  userRepository: context.read<UserRepository>(),
                  storageRepository: context.read<StorageRepository>(),
                  profileBloc: args.context.read<ProfileBloc>()),
              child: EditProfileScreen(),
            ));
  }

  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
    );
  }
}
