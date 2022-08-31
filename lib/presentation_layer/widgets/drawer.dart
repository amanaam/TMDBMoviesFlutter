import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/bloc/authentication_bloc.dart';
import 'package:movies/bloc/movies_bloc.dart';
import 'package:movies/presentation_layer/pages/rated_movies_page.dart';
import 'package:movies/presentation_layer/utils/constants.dart';
import 'package:provider/src/provider.dart';

class MyDrawer extends StatelessWidget {
  final BuildContext homecontext;

  const MyDrawer({
    Key? key,
    required this.homecontext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Drawer(
      child: SafeArea(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(DRAWER_PADDING),
              child: Text(
                APP_TITLE,
                style: textTheme.headline6,
              ),
            ),
            const Divider(
              height: DRAWER_DIVIDER_HEIGHT,
              thickness: DRAWER_DIVIDER_THICKNESS,
            ),
            BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                return ListTile(
                  leading: const Icon(Icons.favorite),
                  title: const Text(RATED_MOVIES_TITLE),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => Provider.value(
                                value: MoviesBloc(),
                                child: const RatedMoviesGrid(),
                              ) // _ is for anonymous route
                          ),
                    );
                    if (state is AuthenticationAuthenticatedState) {
                      context.read<MoviesBloc>().add(
                            MoviesReloadRatedMoviesEvent(
                              state.authenticationRepository,
                            ),
                          );
                    }
                    // context.read<RatedMoviesCubit>().refreshPage();
                  },
                );
              },
            ),
            const Divider(
              height: DRAWER_DIVIDER_HEIGHT,
              thickness: DRAWER_DIVIDER_THICKNESS,
            ),
            const Padding(
              padding: EdgeInsets.all(DRAWER_PADDING),
              child: Text(
                DRAWER_ACTION,
              ),
            ),
            ListTile(
                leading: const Icon(Icons.logout),
                title: const Text(LOG_OUT),
                // selected: _selectedDestination == 3,
                onTap: () {
                  context
                      .read<AuthenticationBloc>()
                      .add(AuthenticationLogoutEvent());
                }),
          ],
        ),
      ),
    );
  }
}
