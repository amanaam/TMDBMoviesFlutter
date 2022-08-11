import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/cubit/authentication_cubit.dart';
import 'package:movies/cubit/rated_movies_cubit.dart';
import 'package:movies/rated_movies_page.dart';
import 'package:provider/src/provider.dart';

class MyDrawer extends StatelessWidget {
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
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'The Movie DB',
              style: textTheme.headline6,
            ),
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Rated Movies'),
            onTap: () => {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const RatedMoviesGrid(),
              )),
              context.read<RatedMoviesCubit>().refreshPage()
            },
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Action',
            ),
          ),
          ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              // selected: _selectedDestination == 3,
              onTap: () => (context.read<AuthenticationCubit>().logout())),
        ],
      ),
    ));
  }
}
