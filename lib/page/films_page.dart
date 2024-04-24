import 'package:ets_ppb/widget/film_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../db/films_database.dart';
import '../model/film.dart';
import 'edit_films_page.dart';
import 'film_detail_page.dart';

class FilmsPage extends StatefulWidget {
  const FilmsPage({Key? key}) : super(key: key);

  @override
  State<FilmsPage> createState() => _FilmsPageState();
}

class _FilmsPageState extends State<FilmsPage> {
  late List<Film> films;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshFilms();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future refreshFilms() async {
    setState(() => isLoading = true);

    films = await FilmsDatabase.instance.readAllFilms();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'Notes',
        style: TextStyle(fontSize: 24),
      ),
      actions: const [Icon(Icons.search), SizedBox(width: 12)],
    ),
    body: isLoading
        ? const CircularProgressIndicator()
        : films.isEmpty
        ? const Text(
      'No Films',
      style: TextStyle(color: Colors.white, fontSize: 24),
    )
        : buildNotes(),
    floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.black,
      child: const Icon(Icons.add),
      onPressed: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AddEditFilmPage()),
        );

        refreshFilms();
      },
    ),
  );

  Widget buildNotes() => StaggeredGrid.count(
    // itemCount: notes.length,
    // staggeredTileBuilder: (index) => StaggeredTile.fit(2),
      crossAxisCount: 2,
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      children: List.generate(
        films.length,
            (index) {
          final film = films[index];

          return StaggeredGridTile.fit(
            crossAxisCellCount: 1,
            child: GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FilmDetailPage(filmId: film.id!),
                ));

                refreshFilms();
              },
              child: FilmCardWidget(film: film, index: index),
            ),
          );
        },
      ));
}
