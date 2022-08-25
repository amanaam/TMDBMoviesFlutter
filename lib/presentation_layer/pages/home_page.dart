import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/cubit/rated_movies_cubit.dart';
import 'package:movies/cubit/search_movies_cubit.dart';
import 'package:movies/presentation_layer/pages/search_page.dart';
import 'package:movies/presentation_layer/utils/constants.dart';
import 'package:movies/presentation_layer/utils/size_config.dart';
import 'package:movies/presentation_layer/widgets/drawer.dart';
import 'package:movies/presentation_layer/widgets/linear_progress_indicator_widget.dart';
import 'package:movies/presentation_layer/widgets/popular_movies_grid.dart';
import 'package:movies/presentation_layer/widgets/top_movies_grid.dart';
import 'package:movies/repositories/user_repository.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Genre> selectedGenreList = [];

  void _openFilterDialog(genres) async {
    await FilterListDialog.display<Genre>(
      context,
      listData: genres,
      selectedListData: selectedGenreList,
      choiceChipLabel: (genre) => genre!.name,
      validateSelectedItem: (list, val) => list!.contains(val),
      height: SizeConfig.screenWidth * 1.25,
      width: SizeConfig.screenWidth * 0.85,
      insetPadding: const EdgeInsets.all(NORMAL_PADDING),
      onItemSearch: (genre, query) {
        return genre.name.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        setState(() {
          selectedGenreList = List.from(list!);
        });
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Genre> genres = [];
    // context.read<AuthenticationCubit>().userRepository.genres;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(text: HOME_TAB_TITLE_1),
                Tab(text: HOME_TAB_TITLE_2),
              ],
            ),
            title: Text(widget.title),
            actions: [
              IconButton(
                  onPressed: () {
                    _openFilterDialog(genres);
                  },
                  icon: const Icon(Icons.filter_list)),
              // Navigate to the Search Screen
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (context) => SearchMoviesCubit(),
                          child: SearchPage(),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.search)),
            ],
          ),
          body: BlocBuilder<RatedMoviesCubit, RatedMoviesState>(
            builder: (context, state) {
              if (state is LoadedRatedMovies) {
                return TabBarView(
                  children: [
                    PopularMoviesGrid(genres: selectedGenreList),
                    TopMoviesGrid(genres: selectedGenreList)
                  ],
                );
              } else {
                return const CustomLinearProgressIndicator();
              }
            },
          ),
          drawer: const MyDrawer(),
        ));
  }
}
