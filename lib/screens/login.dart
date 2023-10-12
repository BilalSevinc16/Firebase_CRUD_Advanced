import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/screens/home.dart';
import 'package:flutter_crud/screens/register.dart';
import 'package:flutter_crud/services/auth.dart';
import 'package:flutter_crud/shared/constants.dart';
import 'package:flutter_crud/shared/loading.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _loginFormKey = GlobalKey<FormState>();

  bool loading = false;
  String error = '';

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _auth = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              title: const Text('LogIn'),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _loginFormKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
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
                          onPressed: () async {
                            if (_loginFormKey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });
                              try {
                                // Log in user by firebase auth
                                User? user =
                                    await _auth.logInWithEmailAndPassword(
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
                          child: const Text("Login"),
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
                      const Text("Don't have an account?"),
                      TextButton(
                        child: const Text('Register'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Register(),
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
