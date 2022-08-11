import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/cubit/search_movies_cubit.dart';
import 'package:movies/widgets/drawer.dart';
import 'package:movies/widgets/popular_movies_grid.dart';
import 'package:movies/widgets/search_page.dart';
import 'package:movies/widgets/top_movies_grid.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Popular'),
                Tab(text: 'Top Rated'),
              ],
            ),
            title: Text(widget.title),
            actions: [
              IconButton(
                  onPressed: () => {}, icon: const Icon(Icons.filter_list)),
              // Navigate to the Search Screen
              IconButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => BlocProvider(
                            create: (context) => SearchMoviesCubit(),
                            child: SearchPage(),
                          ))),
                  icon: const Icon(Icons.search)),
            ],
          ),
          body: const TabBarView(
            children: [PopularMoviesGrid(), TopMoviesGrid()],
          ),
          drawer: MyDrawer(),
        ));
  }
}
