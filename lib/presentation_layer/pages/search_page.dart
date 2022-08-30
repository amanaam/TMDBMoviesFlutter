import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/bloc/movies_bloc.dart';
import 'package:movies/presentation_layer/widgets/linear_progress_indicator_widget.dart';
import 'package:movies/presentation_layer/widgets/search_movie_card.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Timer? _debounce;
  final searchTextController = TextEditingController();

  void _search() {
    print('Second text field: ${searchTextController.text}');
  }

  void _on_search(BuildContext context, String text) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 1000),
      () {
        BlocProvider.of<MoviesBloc>(context).add(
          MoviesSearchEvent(text),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    searchTextController.addListener(_search);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MoviesBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: BlocBuilder<MoviesBloc, MoviesState>(
              builder: _searchBarBlocBuilder,
            ),
          ),
        ),
        body: BlocBuilder<MoviesBloc, MoviesState>(
          builder: _searchBodyBlocBuilder,
        ),
      ),
    );
  }

  Widget _searchBarBlocBuilder(
    BuildContext context,
    MoviesState state,
  ) {
    return Center(
      child: TextField(
        onChanged: (text) {
          _on_search(context, text);
        },
        controller: searchTextController,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                searchTextController.clear();
              },
            ),
            hintText: 'Search...',
            border: InputBorder.none),
      ),
    );
  }

  Widget _searchBodyBlocBuilder(
    BuildContext context,
    MoviesState state,
  ) {
    if (state is MoviesInitialState) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            'Search for movies',
          ),
        ),
      );
    }
    if (state is MoviesLoadedState) {
      return ListView(
        children: state.movieRepository.searchMoviesList.map<Widget>(
          (movie) {
            return SearchMovieCard(
              movie: movie,
            );
          },
        ).toList(),
      );
    }
    if (state is MoviesLoadingState) {
      return const CustomLinearProgressIndicator();
    }
    if (state is MoviesLoadingFailedState) {
      return const Center(
        child: Text("Failed to Load Movies! Please try again"),
      );
    }
    return Container();
  }
}
