import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/cubit/authentication_cubit.dart';
import 'package:movies/login.dart';

import 'cubit/authentication_cubit.dart';
import 'cubit/authentication_state.dart';
import 'cubit/popular_movies_cubit.dart';
import 'cubit/rated_movies_cubit.dart';
import 'cubit/top_movies_cubit.dart';
import 'home_page.dart';

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
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const MaterialColor primaryBlack = MaterialColor(
    _blackPrimaryValue,
    <int, Color>{
      50: Color(0xFF000000),
      100: Color(0xFF000000),
      200: Color(0xFF000000),
      300: Color(0xFF000000),
      400: Color(0xFF000000),
      500: Color(_blackPrimaryValue),
      600: Color(0xFF000000),
      700: Color(0xFF000000),
      800: Color(0xFF000000),
      900: Color(0xFF000000),
    },
  );
  static const int _blackPrimaryValue = 0xFF000000;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationCubit>(
        create: (context) => AuthenticationCubit(),
        child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationAuthenticated) {
              context.read<RatedMoviesCubit>().loadRatedMovies(
                  context.read<AuthenticationCubit>().userRepository);
              return MaterialApp(
                theme: ThemeData(
                  primarySwatch: primaryBlack,
                  brightness: Brightness.light,
                  backgroundColor: Colors.black,
                ),
                home: const MyHomePage(title: 'TMDB Movies'),
              );
            } else {
              return MaterialApp(
                title: 'Flutter Demo',
                theme: ThemeData(
                    primarySwatch: primaryBlack, brightness: Brightness.light),
                home: const Login(),
              );
            }
          },
        ));
  }
}
