import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies/cubit/authentication_cubit.dart';

import 'cubit/authentication_state.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text("TMDB Movies"),
        //
        // ),
        body: Center(
            child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [
                    0.1,
                    0.4,
                    0.6,
                    0.9,
                  ],
                  colors: [
                    Colors.yellow,
                    Colors.red,
                    Colors.indigo,
                    Colors.teal,
                  ],
                )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: SvgPicture.network(
                            'https://www.themoviedb.org/assets/2/v4/logos/v2/blue_short-8e7b30f73a4020692ccca9c88bafe5dcb6f8a62a4c6bc55cd9ba82bb2cd95f6c.svg',
                            color: Colors.white,
                            fit: BoxFit.contain,
                          )),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: TextField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Username',
                            fillColor: Colors.white,
                            filled: true,
                          ),
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: TextField(
                          obscureText: true,
                          controller: passwordController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            fillColor: Colors.white,
                            filled: true,
                          ),
                        )),
                    BlocConsumer<AuthenticationCubit, AuthenticationState>(
                      listener: (context, state) {
                        if (state is AuthenticationUnauthenticated) {
                          Scaffold.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  "Authentication failed! username or password is incorrect")));
                        }
                      },
                      builder: (context, state) {
                        if (state is AuthenticationLoading) {
                          return const Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: CircularProgressIndicator(
                                semanticsLabel: 'Linear progress indicator',
                              ));
                        } else {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                context
                                    .read<AuthenticationCubit>()
                                    .authenticate(usernameController.text,
                                        passwordController.text);
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white),
                              child: const Text(
                                'Submit',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          );
                        }
                      },
                    )
                  ],
                ))));
  }
}
