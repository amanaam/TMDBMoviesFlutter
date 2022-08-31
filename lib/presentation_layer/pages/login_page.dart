import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies/bloc/authentication_bloc.dart';
import 'package:movies/presentation_layer/utils/colors.dart';
import 'package:movies/presentation_layer/utils/constants.dart';
import 'package:movies/presentation_layer/utils/size_config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: TMDBColors.gradientStops,
              colors: TMDBColors.gradientColors,
            ),
          ),
          child: _loginForm(),
        ),
      ),
    );
  }

  Widget _loginForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(bottom: 30.0),
          width: SizeConfig.screenWidth,
          child: SvgPicture.network(
            LOGIN_PAGE_ICON,
            color: Colors.white,
            fit: BoxFit.contain,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: PADDING_NORMAL,
            horizontal: PADDING_XL,
          ),
          child: TextField(
            controller: usernameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: LOGIN_USERNAME_FIELD_TEXT,
              fillColor: Colors.white,
              filled: true,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: PADDING_NORMAL, horizontal: PADDING_XL),
          child: TextField(
            obscureText: true,
            controller: passwordController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: LOGIN_PASSWORD_FIELD_TEXT,
              fillColor: Colors.white,
              filled: true,
            ),
          ),
        ),
        BlocConsumer<AuthenticationBloc, AuthenticationState>(
          listener: _blocListener,
          builder: _blocBuilder,
        )
      ],
    );
  }

  void _blocListener(
    BuildContext context,
    AuthenticationState state,
  ) {
    if (state is AuthenticationUnauthenticatedState) {
      Scaffold.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(LOGIN_FAILED_SNACKBAR_TEXT),
          backgroundColor: Colors.red,
        ),
      );
    }
    if (state is AuthenticationAuthenticatedState) {
      Scaffold.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(LOGIN_SUCCESSFUL_SNACKBAR_TEXT),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Widget _blocBuilder(
    BuildContext context,
    AuthenticationState state,
  ) {
    if (state is AuthenticationLoadingState) {
      return const Padding(
        padding: EdgeInsets.symmetric(
          vertical: PADDING_NORMAL,
        ),
        child: CircularProgressIndicator(),
      );
    }
    if (state is AuthenticationInitialState ||
        state is AuthenticationUnauthenticatedState) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: PADDING_NORMAL,
        ),
        child: ElevatedButton(
          onPressed: () {
            context.read<AuthenticationBloc>().add(
                  AuthenticationAuthenticateEvent(
                    usernameController.text,
                    passwordController.text,
                  ),
                );
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
          ),
          child: const Text(
            LOGIN_PAGE_BUTTON,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
