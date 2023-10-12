import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/screens/home.dart';
import 'package:flutter_crud/screens/login.dart';
import 'package:flutter_crud/screens/my_posts.dart';
import 'package:flutter_crud/screens/profile.dart';
import 'package:flutter_crud/screens/register.dart';
import 'package:flutter_crud/services/auth.dart';
import 'package:provider/provider.dart';

class HomeDrawer extends StatelessWidget {
  final AuthService _auth = AuthService();

  HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final bool isAuthenticated = user != null;
    String email = '';

    if (isAuthenticated) {
      email = user.email!;
    } else {
      email = 'Anonymous';
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: ListTile(
              leading: const Icon(Icons.account_circle),
              title: Text(
                email,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Profile(user: user!),
                  ),
                );
              },
            ),
          ),
          if (isAuthenticated) ...[
            InkWell(
              child: ListTile(
                leading: const Icon(Icons.sentiment_very_satisfied),
                title: const Text('My posts'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyPosts(user: user),
                    ),
                  );
                },
              ),
            ),
            InkWell(
              child: ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Sign out'),
                onTap: () async {
                  await _auth.signOut();
                  if (context.mounted) {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Home(),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
          if (!isAuthenticated) ...[
            InkWell(
              child: ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Login'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LogIn(),
                    ),
                  );
                },
              ),
            ),
            InkWell(
              child: ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text('Register'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Register(),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
