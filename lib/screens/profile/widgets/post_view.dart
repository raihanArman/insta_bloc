import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:insta_bloc/models/models.dart';
import 'package:insta_bloc/screens/profile/profile_screen.dart';
import 'package:insta_bloc/screens/widgets/widgets.dart';
import 'package:insta_bloc/extensions/extension.dart';

class PostView extends StatelessWidget {
  final Post post;
  final bool isLiked;

  const PostView({Key? key, required this.post, required this.isLiked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () =>
                Navigator.of(context).pushNamed(ProfileScreen.routeName,
                    arguments: ProfilScreenArgs(
                      userId: post.author.id,
                    )),
            child: Row(
              children: [
                UserProfileImage(
                    radius: 18, profileImageUrl: post.author.profileImageUrl),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(post.author.username,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onDoubleTap: () {},
          child: CachedNetworkImage(
            imageUrl: post.imageUrl,
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height / 2.25,
            width: double.infinity,
          ),
        ),
        Row(
          children: [
            IconButton(
                onPressed: () {},
                icon: isLiked
                    ? Icon(Icons.favorite, color: Colors.red)
                    : Icon(Icons.favorite_outline)),
            IconButton(onPressed: () {}, icon: Icon(Icons.comment_outlined))
          ],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${post.likes} likes',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              SizedBox(
                height: 4,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: post.author.username,
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    TextSpan(text: ' '),
                    TextSpan(text: post.caption),
                  ],
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                post.date.timeAgo(),
                style: TextStyle(
                    color: Colors.grey[600], fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
      ],
    );
  }
}
