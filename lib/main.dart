import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/presentation_layer/pages/home_page.dart';
import 'package:movies/presentation_layer/pages/login_page.dart';
import 'package:movies/presentation_layer/utils/colors.dart';
import 'package:movies/presentation_layer/utils/constants.dart';

import 'app_config.dart';
import 'bloc/authentication_bloc.dart';

void main() {
  AppConfig.setEnvironment(Environment.PROD);
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      create: (context) => AuthenticationBloc(),
      child: MaterialApp(
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSwatch().copyWith(primary: TMDBColors.black),
          brightness: Brightness.light,
          backgroundColor: Colors.black,
        ),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationAuthenticatedState) {
              return const HomePage(title: APP_TITLE);
            } else {
              //Not authenticated
              return const LoginPage();
            }
          },
        ),
      ),
    );
  }
}
