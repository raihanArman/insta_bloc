import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_bloc/blocs/blocs.dart';
import 'package:insta_bloc/repositories/repositories.dart';
import 'package:insta_bloc/screens/profile/bloc/profile_bloc.dart';
import 'package:insta_bloc/screens/profile/widgets/post_view.dart';
import 'package:insta_bloc/screens/profile/widgets/widgets.dart';
import 'package:insta_bloc/screens/widgets/widgets.dart';

class ProfilScreenArgs {
  final String userId;
  ProfilScreenArgs({required this.userId});
}

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';

  static Route route({required ProfilScreenArgs args}) {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (context) => BlocProvider<ProfileBloc>(
              create: (_) => ProfileBloc(
                  userRepository: context.read<UserRepository>(),
                  postRepository: context.read<PostRepository>(),
                  authBloc: context.read<AuthBloc>())
                ..add(ProfileLoadUser(userId: args.userId)),
              child: ProfileScreen(),
            ));
  }

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

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
        print("mantap ${state.posts.length}");
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
            body: _buildBody(state));
      },
    );
  }

  Widget _buildBody(ProfileState state) {
    switch (state.status) {
      case ProfileStatus.loading:
        return Center(
          child: CircularProgressIndicator(),
        );
      default:
        return RefreshIndicator(
          onRefresh: () async {
            context
                .read<ProfileBloc>()
                .add(ProfileLoadUser(userId: state.user.id));
          },
          child: CustomScrollView(
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
                              posts: state.posts.length,
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
              ),
              SliverToBoxAdapter(
                  child: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.grid_on, size: 20)),
                  Tab(icon: Icon(Icons.list, size: 20))
                ],
                indicatorWeight: 3,
                controller: _tabController,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.grey,
                onTap: (i) => context
                    .read<ProfileBloc>()
                    .add(ProfileToggleGridView(isGridView: i == 0)),
              )),
              state.isGridView
                  ? SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final post = state.posts[index];
                        return GestureDetector(
                          onTap: () {},
                          child: CachedNetworkImage(
                              imageUrl: post!.imageUrl, fit: BoxFit.cover),
                        );
                      }, childCount: state.posts.length),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                      final post = state.posts[index];
                      return PostView(
                        post: post!,
                        isLiked: false,
                      );
                    }, childCount: state.posts.length)),
            ],
          ),
        );
    }
  }
}
