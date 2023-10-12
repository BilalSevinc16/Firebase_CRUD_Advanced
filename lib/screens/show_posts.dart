import 'package:flutter/material.dart';
import 'package:flutter_crud/models/post.dart';

class ShowPosts extends StatefulWidget {
  const ShowPosts({Key? key, required this.post}) : super(key: key);
  final Post post;

  @override
  State<ShowPosts> createState() => _ShowPostsState();
}

class _ShowPostsState extends State<ShowPosts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShowPosts'),
      ),
      body: Card(
        color: Colors.cyan[50],
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ListTile(
          title: Text(
            "Title : ${widget.post.title}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Content : ${widget.post.content}",
          ),
        ),
      ),
    );
  }
}
