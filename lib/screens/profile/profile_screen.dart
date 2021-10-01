import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_bloc/blocs/blocs.dart';
import 'package:insta_bloc/screens/profile/bloc/profile_bloc.dart';
import 'package:insta_bloc/screens/profile/widgets/widgets.dart';
import 'package:insta_bloc/screens/widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.error) {
          showDialog(
              context: context,
              builder: (context) =>
                  ErrorDialog(message: state.failure.message));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.user.username),
            actions: [
              if (state.isCurrentUser)
                IconButton(
                    onPressed: () =>
                        context.read<AuthBloc>().add(AuthLogoutRequested()),
                    icon: Icon(Icons.exit_to_app))
            ],
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(24, 32, 24, 0),
                      child: Row(
                        children: [
                          UserProfileImage(
                              radius: 40,
                              profileImageUrl: state.user.profileImageUrl),
                          ProfileStats(
                              isCurrentUser: state.isCurrentUser,
                              isFollowing: state.isFollowing,
                              posts: 0,
                              followers: state.user.followers,
                              following: state.user.following)
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: ProfileInfo(
                          username: state.user.username, bio: state.user.bio),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
