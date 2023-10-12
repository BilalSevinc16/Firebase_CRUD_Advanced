import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/screens/home.dart';
import 'package:flutter_crud/services/database.dart';
import 'package:flutter_crud/shared/constants.dart';
import 'package:flutter_crud/shared/loading.dart';
import 'package:provider/provider.dart';

class NewPost extends StatefulWidget {
  const NewPost({super.key});

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final _newPostFormKey = GlobalKey<FormState>();

  bool loading = false;
  String error = '';

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  final _db = DatabaseService();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              title: const Text('NewPost'),
            ),
            body: Container(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _newPostFormKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Title'),
                        controller: _titleController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter Title";
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
                          onPressed: () async {
                            if (_newPostFormKey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });
                              try {
                                // Log in user by firebase auth
                                final user =
                                    Provider.of<User>(context, listen: false);
                                dynamic result = await _db.createPost(
                                  user.uid,
                                  _titleController.text,
                                  _contentController.text,
                                );

                                if (result != null) {
                                  if (context.mounted) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Home(),
                                      ),
                                    );
                                  }
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
                          },
                          child: const Text("Save post"),
                        ),
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
