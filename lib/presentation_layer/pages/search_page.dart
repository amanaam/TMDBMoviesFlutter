import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/cubit/search_movies_cubit.dart';
import 'package:movies/presentation_layer/widgets/search_movie_card.dart';
import 'package:provider/src/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchTextController = TextEditingController();

  void _search() {
    print('Second text field: ${searchTextController.text}');
  }

  void _on_search(BuildContext context, String text) {
    context.read<SearchMoviesCubit>().loadSearchMovies(text);
  }

  @override
  void initState() {
    super.initState();
    searchTextController.addListener(_search);
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
        )),
        body: BlocBuilder<SearchMoviesCubit, SearchMoviesState>(
            builder: (context, state) {
          if (state is SearchMoviesInitial) {
            return const Center(
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text('Search for movies')),
            );
          } else if (state is LoadedSearchMovies) {
            return ListView(
                children: context
                    .read<SearchMoviesCubit>()
                    .searchMovies
                    .searchMoviesList
                    .map<Widget>((movie) {
              return SearchMovieCard(
                genre: '',
                title: movie['title'] ?? '',
                image: movie['poster_path'] != null
                    ? 'https://image.tmdb.org/t/p/w200' + movie['poster_path']
                    : '',
                year: movie['release_date'] ?? '',
                description: movie['overview'] ?? '',
                id: movie['id'],
              );
            }).toList());
          } else {
            return const Center(
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: CircularProgressIndicator(
                    semanticsLabel: 'Linear progress indicator',
                  )),
            );
          }
        }));
  }
}
