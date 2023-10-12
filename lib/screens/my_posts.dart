import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/models/post.dart';
import 'package:flutter_crud/screens/edit_post.dart';
import 'package:flutter_crud/screens/new_post.dart';
import 'package:flutter_crud/screens/show_posts.dart';
import 'package:flutter_crud/services/database.dart';
import 'package:flutter_crud/shared/loading.dart';

class MyPosts extends StatefulWidget {
  const MyPosts({
    Key? key,
    required this.user,
  }) : super(key: key);
  final User user;

  @override
  State<MyPosts> createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyPosts'),
      ),
      body: StreamBuilder<List<Post>>(
        stream: DatabaseService(uid: widget.user.uid).individualPosts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Post>? posts = snapshot.data;
            return ListView.builder(
              itemCount: posts!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    posts[index].title!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(posts[index].content!),
                  trailing: PopupMenuButton(
                    onSelected: (result) async {
                      final type = result['type'];
                      final post = result['value'];
                      switch (type) {
                        case 'edit':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPost(post: post),
                            ),
                          );
                          break;
                        case 'delete':
                          DatabaseService(uid: widget.user.uid)
                              .deletePost(post.id);
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      PopupMenuItem(
                          value: {'type': 'edit', 'value': posts[index]},
                          child: const Text('Edit')),
                      PopupMenuItem(
                          value: {'type': 'delete', 'value': posts[index]},
                          child: const Text('Delete')),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowPosts(post: posts[index]),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return const Loading();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewPost(),
            ),
          );
        },
        tooltip: 'New Post',
        child: const Icon(Icons.note_add),
      ),
    );
  }
}
