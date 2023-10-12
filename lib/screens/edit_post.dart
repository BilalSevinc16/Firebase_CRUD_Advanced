import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/models/post.dart';
import 'package:flutter_crud/services/database.dart';
import 'package:flutter_crud/shared/constants.dart';
import 'package:provider/provider.dart';

class EditPost extends StatefulWidget {
  const EditPost({
    Key? key,
    required this.post,
  }) : super(key: key);
  final Post post;

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  final _editPostFormKey = GlobalKey<FormState>();

  bool loading = false;
  String error = '';

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _titleController.text = widget.post.title!;
    _contentController.text = widget.post.content!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EditPost'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _editPostFormKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Title'),
                  controller: _titleController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter title";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration:
                      textInputDecoration.copyWith(hintText: 'Contents'),
                  controller: _contentController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter contents";
                    }
                    return null;
                  },
                ),
                Container(
                  margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Update post"),
                      onPressed: () async {
                        if (_editPostFormKey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                          try {
                            // Log in user by firebase auth
                            final user =
                                Provider.of<User>(context, listen: false);
                            dynamic result =
                                await DatabaseService(uid: user.uid).editPost(
                                    widget.post.id!,
                                    _titleController.text,
                                    _contentController.text);

                            if (result != null) {
                              if (context.mounted) {
                                Navigator.pop(context);
                              }

                              loading = false;
                            } else {
                              setState(() {
                                error = 'Check your information!';
                                loading = false;
                              });
                            }
                          } catch (e) {
                            print('An error occurred!!: $e');
                          }
                        }
                      }),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(error,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14.0,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
