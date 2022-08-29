import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/bloc/movies_bloc.dart';
import 'package:movies/presentation_layer/widgets/linear_progress_indicator_widget.dart';
import 'package:movies/presentation_layer/widgets/search_movie_card.dart';
import 'package:provider/src/provider.dart';

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
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      context.read<MoviesBloc>().add(MoviesSearchEvent(text));
    });
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              context.read<MoviesBloc>().add(MoviesInitialEvent());
            }),
        // The search area heresss
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Center(
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
          ),
        ),
      ),
      body: BlocBuilder<MoviesBloc, MoviesState>(
        builder: (context, state) {
          if (state is MoviesInitialState) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Sear ch for movies',
                ),
              ),
            );
          } else if (state is MoviesLoadedState) {
            return ListView(
              children: state.movieRepository.searchMoviesList.map<Widget>(
                (movie) {
                  return SearchMovieCard(
                    movie: movie,
                  );
                },
              ).toList(),
            );
          } else {
            return const CustomLinearProgressIndicator();
          }
        },
      ),
    );
  }
}
