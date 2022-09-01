import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/bloc/authentication_bloc.dart';
import 'package:movies/bloc/movies_bloc.dart';
import 'package:movies/domain/entities/movie_entity.dart';
import 'package:movies/presentation_layer/pages/search_page.dart';
import 'package:movies/presentation_layer/utils/constants.dart';
import 'package:movies/presentation_layer/utils/size_config.dart';
import 'package:movies/presentation_layer/widgets/custom_drawer.dart';
import 'package:movies/presentation_layer/widgets/custom_progress_indicator.dart';
import 'package:movies/presentation_layer/widgets/movies_grid.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      insetPadding: const EdgeInsets.all(
        PADDING_NORMAL,
      ),
      onItemSearch: (Genre genre, query) {
        return genre.name.toLowerCase().contains(
              query.toLowerCase(),
            );
      },
      onApplyButtonClick: (list) {
        setState(
          () {
            selectedGenreList = List.from(list!);
          },
        );
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MoviesBloc(),
      child: BlocBuilder<MoviesBloc, MoviesState>(
        builder: _blocBuilder,
      ),
    );
  }

  Widget _blocBuilder(
    BuildContext context,
    MoviesState state,
  ) {
    if (state is MoviesInitialState) {
      return Scaffold(
        body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: _authenticationBlocBuilder,
        ),
      );
    }
    if (state is MoviesLoadedState) {
      List<Genre> genres = state.movieRepository.movieGenres;
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: HOME_TAB_TITLE_1,
                ),
                Tab(
                  text: HOME_TAB_TITLE_2,
                ),
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
                  _searchPageRoute(context);
                },
                icon: const Icon(Icons.search),
              ),
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
          drawer: CustomDrawer(
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
            MOVIES_LOADING_FAILED_TEXT,
          ),
        ),
      );
    }
    return const Scaffold(
      body: CustomLinearProgressIndicator(),
    );
  }

  Widget _authenticationBlocBuilder(
    //rename to authenticationBlocBuilder
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

  void _searchPageRoute(
    BuildContext context,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SearchPage(),
      ),
    );
  }
}
