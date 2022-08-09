import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/cubit/authentication_cubit.dart';
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
              'Header',
              style: textTheme.headline6,
            ),
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          const ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Item 1'),
            // selected: _selectedDestination == 0,
            // onTap: () => selectDestination(0),
          ),
          const ListTile(
            leading: Icon(Icons.delete),
            title: Text('Item 2'),
            // selected: _selectedDestination == 1,
            // onTap: () => selectDestination(1),
          ),
          const ListTile(
            leading: Icon(Icons.label),
            title: Text('Item 3'),
            // selected: _selectedDestination == 2,
            // onTap: () => selectDestination(2),
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Label',
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
