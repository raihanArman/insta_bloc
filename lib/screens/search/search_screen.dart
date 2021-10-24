import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_bloc/screens/profile/profile_screen.dart';
import 'package:insta_bloc/screens/search/cubit/search_cubit.dart';
import 'package:insta_bloc/screens/widgets/user_profile_image.dart';
import 'package:insta_bloc/screens/widgets/widgets.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search';

  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
                fillColor: Colors.grey[200],
                filled: true,
                border: InputBorder.none,
                hintText: 'Search users',
                suffixIcon: IconButton(
                    onPressed: () {
                      context.read<SearchCubit>().clearSearch();
                      _textEditingController.clear();
                    },
                    icon: Icon(Icons.clear))),
            textInputAction: TextInputAction.search,
            textAlignVertical: TextAlignVertical.center,
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                context.read<SearchCubit>().searchUsers(value.trim());
              }
            },
          ),
        ),
        body: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            switch (state.status) {
              case SearchStatus.error:
                return CenteredText(text: state.failure.message);
              case SearchStatus.loading:
                return Center(child: CircularProgressIndicator());
              case SearchStatus.loaded:
                return state.users.isNotEmpty
                    ? ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          final user = state.users[index];
                          return ListTile(
                            leading: UserProfileImage(
                                radius: 22,
                                profileImageUrl: user.profileImageUrl),
                            title: Text(
                              user.username,
                              style: TextStyle(fontSize: 16),
                            ),
                            onTap: () => Navigator.of(context).pushNamed(
                                ProfileScreen.routeName,
                                arguments: ProfilScreenArgs(userId: user.id)),
                          );
                        },
                        itemCount: state.users.length,
                      )
                    : CenteredText(text: 'No user found');
              default:
                return SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
