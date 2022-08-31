import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/bloc/authentication_bloc.dart';
import 'package:movies/bloc/movies_bloc.dart';
import 'package:movies/data/models/movie_model.dart';
import 'package:movies/presentation_layer/pages/search_page.dart';
import 'package:movies/presentation_layer/utils/constants.dart';
import 'package:movies/presentation_layer/utils/size_config.dart';
import 'package:movies/presentation_layer/widgets/drawer.dart';
import 'package:movies/presentation_layer/widgets/linear_progress_indicator_widget.dart';
import 'package:movies/presentation_layer/widgets/movies_grid.dart';

Widget reloadMovies(
  BuildContext context,
  AuthenticationState state,
) {
  if (state is AuthenticationAuthenticatedState) {
    context.read<MoviesBloc>().add(
          MoviesGetMoviesEvent(state.authenticationRepository),
        );
  }
  return const CustomLinearProgressIndicator();
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<GenreModel> selectedGenreList = [];

  void _openFilterDialog(genres) async {
    await FilterListDialog.display<GenreModel>(
      context,
      listData: genres,
      selectedListData: selectedGenreList,
      choiceChipLabel: (genre) => genre!.name,
      validateSelectedItem: (list, val) => list!.contains(val),
      height: SizeConfig.screenWidth * 1.25,
      width: SizeConfig.screenWidth * 0.85,
      insetPadding: const EdgeInsets.all(NORMAL_PADDING),
      onItemSearch: (GenreModel genre, query) {
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
    // context.read<AuthenticationCubit>().userRepository.genres;
    return BlocProvider(
      create: (context) => MoviesBloc(),
      child: BlocBuilder<MoviesBloc, MoviesState>(
        builder: _homeBuilder,
      ),
    );
  }

  Widget _homeBuilder(
    BuildContext context,
    MoviesState state,
  ) {
    if (state is MoviesInitialState) {
      return const Scaffold(
        body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: reloadMovies,
        ),
      );
    }
    if (state is MoviesLoadedState) {
      List<GenreModel> genres = state.movieRepository.genres;
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
                icon: const Icon(Icons.filter_list),
              ),
              // Navigate to the Search Screen
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SearchPage(),
                      ),
                    );
                    context.read<MoviesBloc>().add(MoviesInitialEvent());
                  },
                  icon: const Icon(Icons.search)),
            ],
          ),
          body: TabBarView(
            children: [
              MoviesGrid(
                genres: selectedGenreList,
                movies: state.movieRepository.popularList,
              ), //selectedGenreList
              MoviesGrid(
                genres: selectedGenreList,
                movies: state.movieRepository.topRatedList,
              ),
            ],
          ),
          drawer: MyDrawer(
            homecontext: context,
          ),
        ),
      );
    }
    if (state is MoviesLoadingState) {
      return const Scaffold(
        body: CustomLinearProgressIndicator(),
      );
    }
    if (state is MoviesLoadingFailedState) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Failed to Load Movies',
          ),
        ),
      );
    }
    return const Scaffold(
      body: CustomLinearProgressIndicator(),
    );
  }
}
