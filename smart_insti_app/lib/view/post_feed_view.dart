import 'package:flutter/material.dart';

import '../model/post.dart';
import '../model/user_data.dart';
import '../constants/text_styles.dart';
import '../adapter/user_profile.dart';
import 'post_brief_view.dart';

class PostFeedView extends StatefulWidget{
  final Post post;
  final UserData profile;
  final Function like;
  final Function unlike;
  const PostFeedView({
    super.key,
    required this.post,
    required this.profile,
    required this.like,
    required this.unlike
  });

  @override
  State<PostFeedView> createState() => PostFeedViewState();
}

class PostFeedViewState extends State<PostFeedView>{
  // get this from auth
  String ldap = 'user_id';
  @override
  Widget build(BuildContext context){
    final double width = MediaQuery.of(context).size.width;

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextButton(
            onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:(context) =>
                   UserProfile(
                    ldapId: widget.post.postedBy,
                    viewerLdapId: ldap,
                  ),
                )
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: width*0.01,
                horizontal: width*0.01
              ),
              child: Row(
                children: [
                  // Avatar
                  Expanded(
                    child: ClipOval(
                      child:
                      (widget.profile.profilePhotoURL != '') ?
                      Image(
                        image: NetworkImage(widget.profile.profilePhotoURL),
                      )
                      : const Image(
                        image: NetworkImage("https://logodix.com/logo/1070509.png"),
                      ),
                    )
                  ),
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: EdgeInsets.only(left: width*0.01),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.profile.username,
                            style: TextStyles.title,
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            widget.profile.userID,
                            style: TextStyles.subtitle,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    )
                  ),
                ],
              ),
            )
          ),

          const Divider(),

          PostBriefView(post: widget.post),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(width: 8),
              (widget.post.likedBy.contains(ldap))
              ? IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: (){
                  widget.unlike(widget.post);
                },
              )
              : IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: (){
                  widget.like(widget.post);
                },
              ),
              Text(
                widget.post.likedBy.length.toString(),
                style: TextStyles.boldCount,
                ),
              IconButton(
                icon: const Icon(Icons.chat),
                onPressed: (){
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
