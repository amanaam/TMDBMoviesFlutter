import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/presentation_layer/pages/home_page.dart';
import 'package:movies/presentation_layer/pages/login_page.dart';
import 'package:movies/presentation_layer/utils/colors.dart';
import 'package:movies/presentation_layer/utils/constants.dart';

import 'bloc/authentication_bloc.dart';
import 'cubit/popular_movies_cubit.dart';
import 'cubit/rated_movies_cubit.dart';
import 'cubit/top_movies_cubit.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider<PopularMoviesCubit>(
      create: (BuildContext context) => PopularMoviesCubit(),
    ),
    BlocProvider<TopMoviesCubit>(
      create: (BuildContext context) => TopMoviesCubit(),
    ),
    BlocProvider<RatedMoviesCubit>(
      create: (BuildContext context) => RatedMoviesCubit(),
    ),
  ], child: const MyApp()));
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
              return const MyHomePage(title: APP_TITLE);
            } else {
              //Not authenticated
              return const Login();
            }
          },
        ),
      ),
    );
  }
}
