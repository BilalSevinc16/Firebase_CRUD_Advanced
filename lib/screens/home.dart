import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/models/post.dart';
import 'package:flutter_crud/screens/home_drawer.dart';
import 'package:flutter_crud/screens/login.dart';
import 'package:flutter_crud/screens/new_post.dart';
import 'package:flutter_crud/screens/show_posts.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final posts = Provider.of<List<Post>?>(context) ?? [];
    final bool isAuthenticated = user != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: HomeDrawer(),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              posts[index].title!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(posts[index].content!),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isAuthenticated) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NewPost(),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LogIn(),
              ),
            );
          }
        },
        tooltip: isAuthenticated ? 'New Post' : 'Login',
        child: isAuthenticated
            ? const Icon(Icons.note_add)
            : const Icon(Icons.settings_backup_restore),
      ),
    );
  }
}
