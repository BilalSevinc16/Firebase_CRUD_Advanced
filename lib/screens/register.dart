import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/screens/home.dart';
import 'package:flutter_crud/screens/login.dart';
import 'package:flutter_crud/services/auth.dart';
import 'package:flutter_crud/shared/constants.dart';
import 'package:flutter_crud/shared/loading.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _registerFormKey = GlobalKey<FormState>();

  bool loading = false;
  String error = '';

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _auth = AuthService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Register'),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _registerFormKey,
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
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Email'),
                        controller: _emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your Email";
                          } else if (!EmailValidator.validate(value)) {
                            return "Please enter a valid Email";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Password'),
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
                      Container(
                        margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            if (_registerFormKey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });
                              try {
                                // Register user by firebase auth
                                User? user =
                                    await _auth.registerWithEmailAndPassword(
                                        _nameController.text,
                                        _emailController.text,
                                        _passwordController.text);

                                if (user != null) {
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
                          child: const Text("Register"),
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
                      const SizedBox(
                        height: 20.0,
                      ),
                      const Text('Do you have an account?'),
                      TextButton(
                        child: const Text('Login'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LogIn(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
