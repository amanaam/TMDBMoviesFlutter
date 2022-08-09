import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/cubit/authentication_cubit.dart';
import 'package:movies/main.dart';
import 'package:movies/repositories/user_repository.dart';
import 'package:provider/src/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        appBar: AppBar(
          title: const Text("TMDB Movies"),
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Column(
          children: <Widget>[
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                  ),
                )),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
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
                        context.read<AuthenticationCubit>().authenticate(
                            usernameController.text, passwordController.text);
                      },
                      child: const Text('Submit'),
                    ),
                  );
                }
              },
            )
          ],
        ))));
  }
}
