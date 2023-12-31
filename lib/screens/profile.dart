import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/models/user.dart';
import 'package:flutter_crud/services/database.dart';
import 'package:flutter_crud/shared/constants.dart';
import 'package:flutter_crud/shared/loading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _profileFormKey = GlobalKey<FormState>();

  bool loading = false;
  String error = '';

  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _userImageController = TextEditingController();

  Userr? user;
  File? _image;

  @override
  void dispose() {
    _nameController.dispose();
    _userImageController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Future getUser() async {
      var currentUser = await DatabaseService().getProfile(widget.user.uid);
      setState(() {
        user = currentUser;
        _nameController.text = currentUser.name;
        _userImageController.text = currentUser.userImage ?? '';
      });
    }

    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      var image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      setState(() {
        _image = File(image!.path);
      });
    }

    Future uploadPic(BuildContext context) async {
      String fileName = basename(_image!.path);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);

      UploadTask uploadTask = firebaseStorageRef.putFile(_image!);
      var url = await (await uploadTask).ref.getDownloadURL();
      _userImageController.text = url.toString();
      print('Profile picture uploaded');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile picture uploaded'),
          ),
        );
      }
    }

    return loading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
            ),
            body: Builder(
              builder: (context) => SingleChildScrollView(
                child: Form(
                  key: _profileFormKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration:
                              textInputDecoration.copyWith(hintText: 'Name'),
                          controller: _nameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter Name";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Password'),
                          obscureText: true,
                          controller: _passwordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter Password";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Verification Password'),
                          obscureText: true,
                          controller: _confirmPasswordController,
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return "Your passwords do not match";
                            }
                            return null;
                          },
                        ),
                        CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.cyanAccent[400],
                          child: ClipOval(
                            child: SizedBox(
                              width: 180.0,
                              height: 180.0,
                              child: (_image != null)
                                  ? Image.file(
                                      _image!,
                                      fit: BoxFit.fill,
                                    )
                                  : (_userImageController.text != '')
                                      ? Image.network(
                                          _userImageController.text,
                                          fit: BoxFit.fill,
                                        )
                                      : Image.network(
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcR8QMTmCUwPeDMiZ0pZFQqQkHCQvcWY7ECb_Lcfc4QqqS2PL9rb&usqp=CAU',
                                          fit: BoxFit.fill,
                                        ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        IconButton(
                            icon: const Icon(
                              Icons.camera,
                              size: 30.0,
                            ),
                            onPressed: () {
                              getImage();
                            }),
                        const SizedBox(height: 10),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColorDark,
                                  elevation: 4.0,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColorDark,
                                  elevation: 4.0,
                                ),
                                onPressed: () {
                                  uploadPic(context);
                                },
                                child: const Text(
                                  'Upload image',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ]),
                        Container(
                          margin: const EdgeInsets.only(
                            top: 16.0,
                            bottom: 16.0,
                          ),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text("Update"),
                              onPressed: () async {
                                if (_profileFormKey.currentState!.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  try {
                                    await DatabaseService(uid: widget.user.uid)
                                        .editProfile(
                                      widget.user.uid,
                                      _nameController.text,
                                      _userImageController.text,
                                    );

                                    if (_passwordController.text.isNotEmpty) {
                                      User updatedUser =
                                          FirebaseAuth.instance.currentUser!;
                                      updatedUser
                                          .updatePassword(
                                              _passwordController.text)
                                          .then((_) {
                                        //getUser();
                                      }).catchError((e) {
                                        print(error.toString());
                                      });
                                    }
                                    setState(() {
                                      error = 'Profile updated!';
                                      loading = false;
                                    });
                                    //Navigator.pop(context);
                                  } catch (e) {
                                    setState(() {
                                      error = 'Check your information!';
                                      loading = false;
                                    });
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
            ),
          );
  }
}
