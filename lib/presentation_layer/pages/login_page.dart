import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies/bloc/authentication_bloc.dart';
import 'package:movies/presentation_layer/utils/constants.dart';
import 'package:movies/presentation_layer/utils/size_config.dart';

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
    SizeConfig().init(context);
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
                    width: SizeConfig.screenWidth,
                    child: SvgPicture.network(
                      LOGIN_PAGE_ICON,
                      color: Colors.white,
                      fit: BoxFit.contain,
                    )),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: NORMAL_PADDING, horizontal: 20),
                  child: TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: LOGIN_USERNAME_FIELD_TEXT,
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: NORMAL_PADDING, horizontal: 20),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: LOGIN_PASSWORD_FIELD_TEXT,
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  )),
              BlocConsumer<AuthenticationBloc, AuthenticationState>(
                listener: (context, state) {
                  if (state is AuthenticationUnauthenticatedState) {
                    Scaffold.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(LOGIN_FAILED_SNACKBAR_TEXT),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is AuthenticationLoadingState) {
                    return const Padding(
                        padding: EdgeInsets.symmetric(vertical: NORMAL_PADDING),
                        child: CircularProgressIndicator());
                  } else {
                    return Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: NORMAL_PADDING),
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<AuthenticationBloc>().add(
                              AuthenticationAuthenticateEvent(
                                  usernameController.text,
                                  passwordController.text));
                        },
                        style: ElevatedButton.styleFrom(primary: Colors.white),
                        child: const Text(
                          LOGIN_PAGE_BUTTON,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
